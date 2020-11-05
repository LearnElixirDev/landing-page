defmodule LearnElixirLandingWeb.LayoutView do
  use LearnElixirLandingWeb, :view

  def og_image(conn) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.og_image(template, conn.assigns)
  end

  def title(conn) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.title(template, conn.assigns)
  end

  def og_title(conn) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.og_title(template, conn.assigns)
  end

  def description(conn) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.description(template, conn.assigns)
  end

  def ld_schema(conn) do
    view = conn.private[:phoenix_view]
    template = conn.private[:phoenix_template]

    view.ld_schema(template, conn.assigns)
  end
end
