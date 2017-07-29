use Mix.Config

config :hermex, HermexWeb.Endpoint,
  http: [port: 9090],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :hermex, HermexWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :hermex, Hermex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hermex_dev",
  hostname: "localhost",
  pool_size: 10
