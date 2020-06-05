defmodule LearnElixirLandingWeb.BlogController do
  use LearnElixirLandingWeb, :controller


  @blog_list Enum.flat_map(["dangers_of_genservers"], &[
    &1, String.replace(&1, "_", "-")
  ])

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => blog_name}) when blog_name not in @blog_list do
    render(conn, LearnElixirLandingWeb.ErrorView, "404.html")
  end

  def show(conn, %{"id" => blog_name}) do
    blog_name = String.replace(blog_name, "_", "-")

    render(conn, "show.html", blog_name: "#{blog_name}.md")
  end
end

