use Mix.Config

import_config "./dev.exs"

config :hermex, Hermex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "hermex_dev",
  hostname: "postgres",
  pool_size: 10
