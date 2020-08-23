defmodule LearnElixirLandingWeb.ContactMailerLive do
  require Logger
  use LearnElixirLandingWeb, :live_view

  alias LearnElixirLandingWeb.FormValidators
  alias LearnElixirLanding.Mailer

  @flash_clear_delay :timer.seconds(5)

  def render(assigns) do
    ~L"""
      <%= f = form_for @contact_changeset, "#", [phx_change: :validate, phx_submit: :save, id: "contact-form", class: "form--stacked w-100 center"] %>
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
          <%= textarea f, :message, class: 'h4' %>
          <%= error_tag f, :message %>
        </div>

        <div class='form-button'>
          <%= submit "Send", disabled: !@contact_changeset.valid?, class: "button-small button-purple w-100" %>
        </div>
      </form>
    """
  end

  def mount(_params, %{}, socket) do
    {:ok, reset_form(socket)}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_event("validate", %{"contact_mailer" => params}, socket) do
    changeset = FormValidators.validate_changeset(FormValidators.ContactMailer, params)

    {:noreply, assign(socket, :contact_changeset, changeset)}
  end

  def handle_event("save", %{"contact_mailer" => params}, socket) do
    %{"email" => email, "name" => name, "message" => message} = params

    case Mailer.send_contact_email(email, name, message) do
      {:ok, _} ->
        socket = socket |> put_flash(:success, "Email sent successfully") |> reset_form

        setup_delayed_clear_flash()

        {:noreply, socket}

      {:error, e} ->
        Logger.error("Error sending emails: #{inspect e}")

        setup_delayed_clear_flash()

        {:noreply, put_flash(socket, :error, "Email was unable to send, please try again later")}
    end
  end

  defp setup_delayed_clear_flash do
    Process.send_after(self(), :clear_flash, @flash_clear_delay)
  end

  defp reset_form(socket) do
    changeset = FormValidators.ContactMailer.create_changeset()

    assign(socket, :contact_changeset, changeset)
  end
end
