defmodule LearnElixirLandingWeb.IconHelper do
  @moduledoc """
  Give some icons to be used on templates.
  """
  use Phoenix.HTML
  alias LearnElixirLandingWeb.Router.Helpers, as: Routes

  def icon_tag(conn, file_name, name, opts \\ [])

  def icon_tag(conn, file_name, name, opts) when opts === [] do
    opts = Keyword.put(opts, class: "w-100")

    create_svg_icon(conn, file_name, name, opts)
  end

  def icon_tag(conn, file_name, name, opts) do
    opts = if opts[:size] do
      size = Keyword.get(opts, :size, "m")

      Map.put(opts, :class, "le-icon--#{size}")
    else
      opts
    end

    create_svg_icon(conn, file_name, name, opts)
  end

  defp create_svg_icon(conn, file_name, name, opts) do
    content_tag(:svg, opts) do
      tag(:use, "xlink:href": Routes.static_path(conn, "/images/#{file_name}.svg##{name}"))
    end
  end
end
