defmodule LearnElixirLandingWeb.PageView do
  use LearnElixirLandingWeb, :view

  def title("index.html", _) do
    "Learn Elixir"
  end

  def title("methodology.html", _) do
    "Learn Elixir | Methodology"
  end
end
