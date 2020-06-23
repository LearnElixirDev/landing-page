# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

secret_key_base = "8qAyTI8cum0J56zPRam4oachZd7/I5XyqpjCNlIYku0qMci0YP/HqDZ2Zf/PwohZ"

config :learn_elixir_landing, LearnElixirLandingWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :learn_elixir_landing, LearnElixirLandingWeb.Endpoint, server: true
