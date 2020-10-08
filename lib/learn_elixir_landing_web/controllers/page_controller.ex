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

  def thank_you(conn, %{
    "event_start_time" => start_time,
    "invitee_full_name" => full_name
  }) do
    render(conn, "thank_you.html",
      booking_first_name: first_name_from_full(full_name),
      booking_time: booking_time(start_time)
    )
  end

  def thank_you(conn, _) do
    redirect(conn, to: "/")
  end

  defp first_name_from_full(full_name) do
    full_name |> String.split(" ") |> List.first
  end

  defp booking_time(start_time_str) do
    with {:ok, date_time} <- Timex.parse(start_time_str, "{ISO:Extended}"),
         {:ok, time} <- Timex.format(date_time, "{Mfull} {D}, {h12}:{m} {AM}") do
      time
    else
      _ -> ""
    end
  end
end
