defmodule Hermex.WorkerCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Hermex.Repo

      import Hermex.WorkerCase
      import Hermex.Factory
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hermex.Repo)
  end
end
