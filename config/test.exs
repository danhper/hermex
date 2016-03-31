use Mix.Config

config :buildy_push, BuildyPush.Endpoint,
  http: [port: 9091],
  server: false

config :logger, level: :warn

config :buildy_push, BuildyPush.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "buildy_push_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
