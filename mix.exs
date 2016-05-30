defmodule BuildyPush.Mixfile do
  use Mix.Project

  def project do
    [app: :buildy_push,
     version: "0.0.2",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [mod: {BuildyPush, []},
     applications: applications(Mix.env)]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp applications(:staging), do: applications(:prod)
  defp applications(:prod), do: applications(:all) ++ [:rollbax]
  defp applications(:dev), do: applications(:test)
  defp applications(:test), do: applications(:all) ++ [:ex_machina]
  defp applications(_all), do: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                                :phoenix_ecto, :postgrex, :pushex, :joken, :tzdata]

  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0.0-rc.0"},
     {:phoenix_html, "~> 2.4"},
     {:gettext, "~> 0.9"},
     {:cowboy,  "~> 1.0"},
     {:joken,   "~> 1.1"},
     {:rollbax, "~> 0.5"},
     {:exrm,    "~> 1.0"},
     {:timex,   "~> 2.1.4"},
     {:pushex,  github: "tuvistavie/pushex"},
     {:phoenix_live_reload, "~> 1.0", only: [:dev, :docker]},
     {:ex_machina, github: "thoughtbot/ex_machina", only: [:dev, :test]}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
