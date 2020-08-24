defmodule LearnElixirLandingWeb.Router do
  use LearnElixirLandingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LearnElixirLandingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LearnElixirLandingWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/home", PageController, :redirect_to_index
    get "/methodology", PageController, :methodology
    get "/course-content", PageController, :course_content
    get "/contact", PageController, :contact

    live "/live/contact-message", LearnElixirLandingWeb.ContactMailerLive

    get "/uses-of-elixir-task-module", BlogController, :redirect_to_tasks
    get "/dangers-of-genservers", BlogController, :redirect_to_genservers

    get "/terms-and-conditions", PageController, :terms_and_conditions
    get "/privacy-policy", PageController, :privacy_policy

    resources "/blogs", BlogController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LearnElixirLandingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LearnElixirLandingWeb.Telemetry

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/mailbox"]
    end
  end
end
