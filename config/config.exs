use Mix.Config

config :apns, pools: []

config :hermex, HermexWeb.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "WmEoayLkaQTqdWnOTOm/qamFGHaDNHWwrHn7ZmMK58jkIvngCh63cah0XNoEuaIp",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Hermex.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :hermex, Hermex.PushexAppManager,
  cache_timeout: 3600

config :hermex,
  message_worker_impl: Hermex.MessageProcessor.Worker.Remote,
  ecto_repos: [Hermex.Repo]

config :hermex, :auth,
  secret: "secret"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :pushex,
  app_manager_impl: Hermex.PushexAppManager

config :ex_admin,
  repo: Hermex.Repo,
  module: HermexWeb,
  logo_full: "<b>Hermex</b>",
  logo_mini: "<b>H</b>x",
  footer: "Hermex: push notification server by <a href=\"https://github.com/tuvistavie\" target=\"_blank\">Daniel Perez</a> &nbsp;&copy #{DateTime.utc_now.year}",
  modules: [
    HermexWeb.ExAdmin.Dashboard,
    HermexWeb.ExAdmin.App,
    HermexWeb.ExAdmin.Device,
    HermexWeb.ExAdmin.Message,
    HermexWeb.ExAdmin.Topic,
    HermexWeb.ExAdmin.Subscription
  ]

config :hermex, :admin,
  enable: true,
  protected: false,
  username: "hermex",
  password: "password",
  realm: "Hermex Admin"

import_config "#{Mix.env}.exs"

config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :filter_parameters, ["password", "settings"]

config :xain, :after_callback, {Phoenix.HTML, :raw}
