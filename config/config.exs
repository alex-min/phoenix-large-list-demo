# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :large_list_demo,
  ecto_repos: [LargeListDemo.Repo]

# Configures the endpoint
config :large_list_demo, LargeListDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sY4ncSOwlLRWBfmbld1HqsAgBRW0EKpsYZbwdDqP25ZEh/wFJT+Lz8riN2NMk3nV",
  render_errors: [view: LargeListDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LargeListDemo.PubSub,
  live_view: [signing_salt: "YbcEYZR5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
