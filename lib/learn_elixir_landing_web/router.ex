defmodule LearnElixirLandingWeb.Router do
  use LearnElixirLandingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LearnElixirLandingWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/methodology", PageController, :methodology

    get "/uses-of-elixir-task-module", BlogController, :redirect_to_tasks
    get "/dangers-of-genservers", BlogController, :redirect_to_genservers

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
    end
  end
end
