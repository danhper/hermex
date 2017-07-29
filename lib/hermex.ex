defmodule Hermex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(HermexWeb.Endpoint, []),
      supervisor(Hermex.Repo, []),
      supervisor(Hermex.MessageProcessor.Supervisor, []),
      worker(Hermex.PushexAppManager, [])
    ]

    opts = [strategy: :one_for_one, name: Hermex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    HermexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
