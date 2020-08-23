# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :learn_elixir_landing, LearnElixirLandingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0ImhmOLcf+SAJfVyADe2cLYl4nsUgHwU3CLcOz0G1KN5ZU0YZDDYGaKrFJAvOEjZ",
  render_errors: [view: LearnElixirLandingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LearnElixirLanding.PubSub,
  live_view: [signing_salt: "VgcYTx1L"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :learn_elixir_landing, :tracking_tags_enabled?, false

config :learn_elixir_landing, LearnElixirLanding.Mailer,
  adapter: Swoosh.Adapters.Local

config :learn_elixir_landing, :blog_details, %{
  "dangers-of-genservers" => %{
    title: "The Dangers of GenServers in Elixir",
    creation_date: "October 29th 2018",
    creation_iso: "2018-10-29T16:14:24.526Z",
    author: "Mika Kalathil",
    image_url: "https://lure.is/blog-elixir-dangers-of-genservers.ebf92f59742ca6dc324c772021bb59e4.jpeg",
    description: "In this article, we outline some of the technical details of GenServers in Elixir, which is used to serve a large multitude of people with high speed.  This is a deep dive into GenServers and discovering their limitations and strengths."
  },

  "uses-of-elixir-task-module" => %{
    title: "The Many uses of Elixir's Task Module",
    creation_date: "July 25th 2019",
    creation_iso: "2019-07-25T13:15:24.526Z",
    author: "Mika Kalathil",
    image_url: "/blog-images/tasks-img.jpg",
    description: "The Elixir Task module has many uses, in this article we explore how to use the Task module and the ways it can both speed up application and help us create simpler code and architecture"
  }
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
