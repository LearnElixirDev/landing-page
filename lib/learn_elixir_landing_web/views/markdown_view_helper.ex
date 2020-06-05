defmodule LearnElixirLandingWeb.MarkdownViewHelper do
  @blog_path "lib/learn_elixir_landing_web/templates/blog/markdown/"
  @blog_files @blog_path
    |> Path.expand
    |> File.ls!

  @blog_names Enum.map(@blog_files, &String.replace(&1, ".md", ""))
  @blog_contents_map Enum.reduce(@blog_files, %{}, fn file, acc ->
    parsed_markdown = @blog_path |> Path.join(file) |> File.read! |> Earmark.as_html!()

    Map.put(acc, String.replace(file, ".md", ""), parsed_markdown)
  end)

  def blog_names, do: @blog_names

  def render(blog_name) do
    Phoenix.HTML.raw(@blog_contents_map[blog_name])
  end
end
