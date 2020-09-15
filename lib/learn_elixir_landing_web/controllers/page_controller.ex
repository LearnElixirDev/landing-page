defmodule LearnElixirLandingWeb.PageController do
  use LearnElixirLandingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def marketing_lander(conn, _params) do
    render(conn, "marketing_lander.html")
  end

  def methodology(conn, _params) do
    render(conn, "methodology.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end

  def course_content(conn, _params) do
    render(conn, "course_content.html")
  end

  def video(conn, _params) do
    render(conn, "video.html")
  end

  def redirect_to_index(conn, _params) do
    redirect(conn, to: "/")
  end

  def privacy_policy(conn, _params) do
    render(conn, "privacy_policy.html")
  end

  def terms_and_conditions(conn, _params) do
    render(conn, "terms_and_conditions.html")
  end
end
