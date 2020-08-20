defmodule LearnElixirLandingWeb.ContactMailerLive do
  use LearnElixirLandingWeb, :live_view

  def render(assigns) do
    ~L"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(_params, %{}, socket) do
    {:ok, assign(socket, :temperature, 10)}
  end
end
