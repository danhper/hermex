use Mix.Config

config :hermex, Hermex.Endpoint,
  http: [port: System.get_env("PORT") || raise("please provide PORT")],
  url: [host: System.get_env("URL_HOST"), scheme: System.get_env("URL_SCHEME")],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || raise("please provide SECRET_KEY_BASE"),
  server: true

config :hermex, Hermex.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") || raise("please provide DATABASE_URL"),
  pool_size: 20

config :hermex, :auth,
  secret: System.get_env("INTERNAL_JWT_SECRET") || raise("please provide INTERNAL_JWT_SECRET")

config :logger,
  backends: [:console, Rollbax.Logger],
  level: :info

config :logger, Rollbax.Logger,
  level: :error

config :rollbax,
  environment: "production",
  access_token: System.get_env("ROLLBAR_TOKEN") || raise("please provide ROLLBAR_TOKEN")

config :hermex, :admin,
  protected: true,
  username: System.get_env("ADMIN_USERNAME") || raise("please provide ADMIN_USERNAME"),
  password: System.get_env("ADMIN_PASSWORD") || raise("please provide ADMIN_PASSWORD")
