defmodule LearnElixirLandingWeb.BlogController do
  use LearnElixirLandingWeb, :controller

  @blog_list LearnElixirLandingWeb.BlogView.blog_names()

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => blog_name}) when blog_name not in @blog_list do
    conn
      |> put_view(LearnElixirLandingWeb.ErrorView)
      |> render("404.html")
  end

  def show(conn, %{"id" => blog_name}) do
    blog_name = String.replace(blog_name, "_", "-")

    render(conn, "show.html", blog_name: blog_name)
  end
end

