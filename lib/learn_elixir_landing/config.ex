defmodule LearnElixirLanding.Config do
  @app :learn_elixir_landing

  def tracking_tags_enabled? do
    Application.get_env(@app, :tracking_tags_enabled?)
  end

  def blog_details do
    @app
    |> Application.get_env(:blog_details)
    |> Enum.into(%{}, fn {key, value} ->
      {key, struct(LearnElixirLanding.BlogPost, value)}
    end)
  end
end
