use Mix.Config

config :buildy_push, BuildyPush.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("URL_HOST"), scheme: System.get_env("URL_SCHEME")],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE") || raise("please provide SECRET_KEY_BASE")

config :buildy_push, BuildyPush.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") || raise("please provide DATABASE_URL"),
  pool_size: 20

config :logger,
  backends: [:console, Rollbax.Notifier],
  level: :info

config :logger, Rollbax.Notifier,
  level: :error

config :rollbax,
  environment: "production",
  access_token: System.get_env("ROLLBAR_TOKEN") || raise("please provide ROLLBAR_TOKEN")
