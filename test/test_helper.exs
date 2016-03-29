ExUnit.start

Mix.Task.run "ecto.create", ~w(-r BuildyPush.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r BuildyPush.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(BuildyPush.Repo)

