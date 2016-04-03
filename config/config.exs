use Mix.Config

config :buildy_push, BuildyPush.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "WmEoayLkaQTqdWnOTOm/qamFGHaDNHWwrHn7ZmMK58jkIvngCh63cah0XNoEuaIp",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: BuildyPush.PubSub,
           adapter: Phoenix.PubSub.PG2]


config :buildy_push,
  message_worker_impl: BuildyPush.MessageWorker.Remote

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"

config :phoenix, :generators,
  migration: true,
  binary_id: false
