defmodule LearnElixirLandingWeb.BlogView do
  use LearnElixirLandingWeb, :view

  alias LearnElixirLandingWeb.MarkdownViewHelper
  alias LearnElixirLanding.{BlogPost, Config}

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

  def og_title("index.html", _) do
    "Blog Posts"
  end

  def og_title("show.html", %{blog_name: blog_name}) do
    title_case(blog_name)
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

  def description("index.html", _) do
    "Posts from Learn-Elixir on performance, tuning and architecture of Elixir based applications"
  end

  def description("show.html", %{blog_name: blog_name}) do
    %BlogPost{description: description} = Map.get(Config.blog_details(), blog_name, "Not Found")

    description
  end

  def ld_schema("index.html", _) do
    Phoenix.HTML.raw("""
    {
      "@context": "http://schema.org",
      "@type": "Blog",
      "headline": "Posts from Learn-Elixir on performance, tuning and architecture of Elixir based applications",
      "description": "We help developers master Elixir and build work-life balance into a lasting career.",

      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "https://learn-elixir.dev/blogs"
      },

      "author": {
        "@type": "Person",
        "name": "Mika Kalathil"
      },

      "publisher": {
        "@type": "Organization",
        "name": "Learn Elixir",
        "logo": {
          "@type": "ImageObject",
          "url": "https://learn-elixir.dev/favicon.ico"
        }
      }
    }
    """)
  end

  def ld_schema("show.html", %{blog_name: blog_name}) do
    %BlogPost{
      title: title,
      creation_iso: creation_iso,
      image_url: image_url,
      author: author,
      description: description
    } = Map.get(Config.blog_details(), blog_name)

    Phoenix.HTML.raw("""
    {
      "@context": "http://schema.org",
      "@type": "BlogPosting",
      "headline": "#{title}",
      "description": "#{description}",
      "datePublished": "#{creation_iso}",
      "dateModified": "#{creation_iso}",
      "image": ["#{image_url}"],

      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "https://learn-elixir.dev/blogs/#{blog_name}"
      },

      "author": {
        "@type": "Person",
        "name": "#{author}"
      },

      "publisher": {
        "@type": "Organization",
        "name": "Learn Elixir",
        "logo": {
          "@type": "ImageObject",
          "url": "https://learn-elixir.dev/favicon.ico"
        }
      }
    }
    """)
  end
end
