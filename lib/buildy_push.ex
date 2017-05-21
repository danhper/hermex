defmodule BuildyPush do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(BuildyPush.Endpoint, []),
      supervisor(BuildyPush.Repo, []),
      supervisor(BuildyPush.MessageProcessor.Supervisor, []),
      worker(BuildyPush.PushexAppManager, [])
    ]

    opts = [strategy: :one_for_one, name: BuildyPush.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BuildyPush.Endpoint.config_change(changed, removed)
    :ok
  end
end
