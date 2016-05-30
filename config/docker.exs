use Mix.Config

import_config "./dev.exs"

config :buildy_push, BuildyPush.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "buildy_push_dev",
  hostname: "postgres",
  pool_size: 10
