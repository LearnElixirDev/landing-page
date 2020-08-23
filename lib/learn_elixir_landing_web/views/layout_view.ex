defmodule LearnElixirLandingWeb.LayoutView do
  use LearnElixirLandingWeb, :view

  def title(conn, assigns) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.title(template, assigns)
  end

  def og_title(conn, assigns) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.og_title(template, assigns)
  end

  def description(conn, assigns) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.description(template, assigns)
  end

  def ld_schema(conn, assigns) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.ld_schema(template, assigns)
  end
end
