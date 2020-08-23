defmodule LearnElixirLanding.Mailer do
  use Swoosh.Mailer, otp_app: :learn_elixir_landing

  @contact_send_to "support@learn-elixir.dev"
  @contact_send_name "Learn Elixir"
  @contact_send_from "noreply@learn-elixir.dev"

  def send_contact_email(email, name, message) do
    Swoosh.Email.new()
      |> Swoosh.Email.to({@contact_send_name, @contact_send_to})
      |> Swoosh.Email.from({@contact_send_name, @contact_send_from})
      |> Swoosh.Email.reply_to({name, email})
      |> Swoosh.Email.subject("New Contact")
      |> Swoosh.Email.html_body(message)
      |> Swoosh.Email.text_body(message)
      |> deliver
  end
end
