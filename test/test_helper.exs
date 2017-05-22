ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Hermex.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Hermex.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Hermex.Repo, :manual)
