defmodule LearnElixirLandingWeb.PageController do
  use LearnElixirLandingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def methodology(conn, _params) do
    render(conn, "methodology.html")
  end

  def redirect_to_index(conn, _params) do
    redirect(conn, to: "/")
  end
end
