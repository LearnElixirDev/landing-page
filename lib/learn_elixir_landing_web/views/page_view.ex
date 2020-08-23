defmodule LearnElixirLandingWeb.PageView do
  use LearnElixirLandingWeb, :view

  def title("index.html", _) do
    "Learn Elixir"
  end

  def title("methodology.html", _) do
    "Learn Elixir | Methodology"
  end

  def title("course_content.html", _) do
    "Learn Elixir | Course Content"
  end

  def title("contact.html", _) do
    "Learn Elixir | Contact"
  end

  def og_title("index.html", _) do
    "Fast track your Elixir learning experience"
  end

  def og_title("methodology.html", _) do
    "Methodology"
  end

  def og_title("course_content.html", _) do
    "Course Content"
  end

  def og_title("contact.html", _) do
    "Contact Us"
  end

  def description("methodology.html", _) do
    "The methodology we use to help developers master Elixir."
  end

  def description("course_content.html", _) do
    "The content of the course"
  end

  def description(_, _) do
    "We help developers master Elixir and build work-life balance into a lasting career."
  end

  def ld_schema(_, _) do
    Phoenix.HTML.raw("""
    {
      "@context": "http://schema.org",
      "@type": "Corporation",
      "description": "We help developers master Elixir and build work-life balance into a lasting career.",
      "url": "https://learn-elixir.dev",
      "name": "Learn Elixir",

      "logo": {
        "@type": "ImageObject",
        "url": "https://learn-elixir.dev/android-chrome-512x512.png"
      },

      "location": {
        "@type": "City",
        "name": "Vancouver, B.C."
      }
    }
    """)
  end
end
