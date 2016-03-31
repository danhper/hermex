use Mix.Config

config :buildy_push, BuildyPush.Endpoint,
  http: [port: 9090],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :buildy_push, BuildyPush.Endpoint,
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

config :buildy_push, BuildyPush.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "buildy_push_dev",
  hostname: "localhost",
  pool_size: 10
