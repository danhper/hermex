use Mix.Config

config :hermex, Hermex.Endpoint,
  http: [port: 9091],
  server: false

config :logger, level: :warn

if url = System.get_env("DATABASE_URL") do
  config :hermex, Hermex.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: url,
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :hermex, Hermex.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "hermex_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
end


config :hermex,
  message_worker_impl: Hermex.MessageWorker.Dummy


config :pushex,
  sandbox: true
