defmodule LearnElixirLanding.Config do
  @app :learn_elixir_landing

  def tracking_tags_enabled? do
    Application.get_env(@app, :tracking_tags_enabled?)
  end
end
