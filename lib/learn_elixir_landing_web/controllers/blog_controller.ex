defmodule LearnElixirLandingWeb.BlogController do
  use LearnElixirLandingWeb, :controller

  @blog_list LearnElixirLandingWeb.BlogView.blog_names()

  @blog_details_map %{
    "dangers-of-genservers" => %{
      title: "Dangers of GenServers in Elixir",
      creation_date: "October 29th 2018",
      author: "Mika Kalathil",
      image_url: "https://lure.is/blog-elixir-dangers-of-genservers.ebf92f59742ca6dc324c772021bb59e4.jpeg",
    },

    "uses-of-elixir-task-module" => %{
      title: "The Many uses of Elixir's Task Module",
      creation_date: "July 25th 2019",
      author: "Mika Kalathil",
      image_url: "/blog-images/tasks-img.jpg",
    }
  }


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

    render(conn, "show.html", blog_name: blog_name, blog_details: @blog_details_map[blog_name])
  end
end

