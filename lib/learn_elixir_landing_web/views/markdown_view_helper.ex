defmodule LearnElixirLandingWeb.MarkdownViewHelper do
  def render(path, opts) do
    path
      |> load_blog_markdown
      |> Earmark.as_html!(opts)
      |> Phoenix.HTML.raw
  end

  defp load_blog_markdown(path) do
    "lib/learn_elixir_landing_web/templates/blog/markdown/#{path}"
      |> Path.expand
      |> File.read!
  end
end
