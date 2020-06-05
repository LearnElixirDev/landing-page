defmodule LearnElixirLandingWeb.BlogView do
  use LearnElixirLandingWeb, :view

  def title("index.html", _) do
    "Learn Elixir | Blog"
  end

  def title("dangers_of_genservers.html", _) do
    "Learn Elixir | Blog - Dangers of Genservers"
  end
end
