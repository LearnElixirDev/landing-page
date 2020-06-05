defmodule LearnElixirLandingWeb.BlogView do
  use LearnElixirLandingWeb, :view

  def title("index.html", _) do
    "Learn Elixir | Blog"
  end

  def title("show.html", %{blog_name: blog_name}) do
    "Learn Elixir | Blog - #{title_case(blog_name)}"
  end

  defp title_case(str) do
    str
      |> String.split("-")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join(" ")
  end
end
