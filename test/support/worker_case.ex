defmodule BuildyPush.WorkerCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias BuildyPush.Repo

      import BuildyPush.WorkerCase
      import BuildyPush.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BuildyPush.Repo)
  end
end
