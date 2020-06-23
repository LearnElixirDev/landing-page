defmodule LearnElixirLanding.BlogPost do
  @enforce_keys [
    :title,
    :creation_date,
    :creation_iso,
    :author,
    :image_url,
    :description
  ]
  defstruct [
    :title,
    :creation_date,
    :creation_iso,
    :author,
    :image_url,
    :description,
    disabled?: false
  ]
end
