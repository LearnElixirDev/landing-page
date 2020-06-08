defmodule LearnElixirLandingWeb.BlogView do
  use LearnElixirLandingWeb, :view

  alias LearnElixirLandingWeb.MarkdownViewHelper

  @blog_path "lib/learn_elixir_landing_web/templates/blog/markdown/"

  if Mix.env() === :prod do
    @blog_files @blog_path
      |> Path.expand
      |> File.ls!

    @blog_names Enum.map(@blog_files, &String.replace(&1, ".md", ""))
    @blog_contents_map Enum.reduce(@blog_files, %{}, fn file, acc ->

    parsed_markdown = @blog_path
      |> Path.join(file)
      |> MarkdownViewHelper.render

    Map.put(acc, String.replace(file, ".md", ""), parsed_markdown)
  end)
    def blog_names, do: @blog_names

    def render_blog(blog_name) do
      @blog_contents_map[blog_name]
    end
  else
    def blog_names, do: ["dangers-of-genservers", "uses-of-elixir-task-module"]

    def render_blog(blog_name) do
      MarkdownViewHelper.render("#{@blog_path}/#{blog_name}.md")
    end
  end

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
