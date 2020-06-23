defmodule LearnElixirLandingWeb.MarkdownViewHelper do
  def render(path) do
    path
      |> File.read!
      |> Earmark.as_html!(%Earmark.Options{code_class_prefix: "language-"})
      |> render_content
  end

  defp render_content(blog_content) do
    Phoenix.HTML.raw("""
    <div class='markdown-body'>
      #{blog_content}
    </div>
    """)
  end
end
