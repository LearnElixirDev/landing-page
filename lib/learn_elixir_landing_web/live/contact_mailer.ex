defmodule LearnElixirLandingWeb.ContactMailerLive do
  require Logger
  use LearnElixirLandingWeb, :live_view

  alias LearnElixirLandingWeb.FormValidators
  alias LearnElixirLanding.Mailer

  def render(assigns) do
    ~L"""
      <%= f = form_for @contact_changeset, "#", [phx_change: :validate, phx_submit: :save, id: "contact-form", class: ["form--stacked w5 center"]] %>
        <div class='form-group'>
          <%= label f, :email %>
          <%= email_input f, :email %>
          <%= error_tag f, :email %>
        </div>

        <div class='form-group'>
          <%= label f, :name %>
          <%= text_input f, :name %>
          <%= error_tag f, :name %>
        </div>

        <div class='form-group'>
          <%= label f, :message %>
          <%= textarea f, :message %>
          <%= error_tag f, :message %>
        </div>

        <div class='form-button'>
          <%= submit "Save", disabled: !@contact_changeset.valid?, class: "button" %>
        </div>
      </form>
    """
  end

  def mount(_params, %{}, socket) do
    {:ok, reset_form(socket)}
  end

  def handle_event("validate", %{"contact_mailer" => params}, socket) do
    changeset = FormValidators.validate_changeset(FormValidators.ContactMailer, params)

    {:noreply, assign(socket, :contact_changeset, changeset)}
  end

  def handle_event("save", %{"contact_mailer" => params}, socket) do
    %{"email" => email, "name" => name, "message" => message} = params

    case Mailer.send_contact_email(email, name, message) do
      {:ok, _} ->
        socket = socket |> put_flash(:info, "Email sent successfully") |> reset_form

        {:noreply, socket}

      {:error, e} ->
        Logger.error("Error sending emails: #{inspect e}")

        {:noreply, put_flash(socket, :error, "Email was unable to send, please try again later")}
    end
  end

  defp reset_form(socket) do
    changeset = FormValidators.ContactMailer.create_changeset()

    assign(socket, :contact_changeset, changeset)
  end
end
