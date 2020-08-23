defmodule LearnElixirLandingWeb.ContactMailerLive do
  use LearnElixirLandingWeb, :live_view

  alias LearnElixirLandingWeb.FormValidators

  def render(assigns) do
    ~L"""
      <%= f = form_for @contact_changeset, "#", [phx_change: :validate, phx_submit: :save] %>
        <%= label f, :email %>
        <%= email_input f, :email %>
        <%= error_tag f, :email %>

        <%= label f, :name %>
        <%= text_input f, :name %>
        <%= error_tag f, :name %>

        <%= label f, :message %>
        <%= textarea f, :message %>
        <%= error_tag f, :message %>

        <%= submit "Save" %>
      </form>
    """
  end

  def mount(_params, %{}, socket) do
    changeset = FormValidators.ContactMailer.create_changeset()

    {:ok, assign(socket, :contact_changeset, changeset)}
  end

  def handle_event("validate", %{"contact_mailer" => params}, socket) do
    changeset = params
      |> FormValidators.ContactMailer.create_changeset
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :contact_changeset, changeset)}
  end

  def handle_event("save", %{"contact_mailer" => params}, socket) do
    changeset = socket.assigns[:contact_changeset]
      |> FormValidators.ContactMailer.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :contact_changeset, changeset)}
  end
end
