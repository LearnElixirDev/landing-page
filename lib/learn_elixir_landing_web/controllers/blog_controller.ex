defmodule LearnElixirLandingWeb.BlogController do
  use LearnElixirLandingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dangers_of_genservers(conn, _params) do
    render(conn, "dangers_of_genservers.html")
  end
end

