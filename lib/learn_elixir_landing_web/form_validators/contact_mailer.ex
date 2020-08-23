defmodule LearnElixirLandingWeb.FormValidators.ContactMailer do
  use LearnElixirLanding, :schema

  alias LearnElixirLandingWeb.FormValidators.ContactMailer

  embedded_schema do
    field :email, :string
    field :name, :string
    field :message, :string
  end

  @email_regex ~r/.+@.+\..+/
  @required_params [:email, :name, :message]

  def create_changeset(params \\ %{}) do
    changeset(%ContactMailer{}, params)
  end

  def changeset(model_or_changeset, params \\ %{}) do
    model_or_changeset
      |> cast(params, @required_params)
      |> validate_required(@required_params)
      |> validate_email
      |> validate_length(:message, min: 5)
      |> validate_length(:name, min: 2)
  end

  defp validate_email(changeset) do
    validate_change(changeset, :email, :email_format, fn title, email ->
      if email =~ @email_regex do
        []
      else
        [{title, "email is invalid"}]
      end
    end)
  end
end
