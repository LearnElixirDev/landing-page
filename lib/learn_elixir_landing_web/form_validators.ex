defmodule LearnElixirLandingWeb.FormValidators do
  @callback changeset(module | Ecto.Changeset.t, map) :: Ecto.Changeset.t
  @callback changeset(module | Ecto.Changeset.t) :: Ecto.Changeset.t
  @callback create_changeset(map) :: Ecto.Changeset.t
  @callback create_changeset() :: Ecto.Changeset.t

  def validate_changeset(form_schema_module, action \\ :insert, params) do
    changeset = form_schema_module.create_changeset(params)

    case Ecto.Changeset.apply_action(changeset, action) do
      {:ok, _} -> changeset
      {:error, changeset} -> changeset
    end
  end
end
