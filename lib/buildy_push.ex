defmodule BuildyPush do
  use Application

  @extra_workers_mods Enum.map([:message_worker_impl], &Application.get_env(:buildy_push, &1))

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(BuildyPush.Endpoint, []),
      supervisor(BuildyPush.Repo, [])
    ] ++ Enum.filter_map(@extra_workers_mods,
                         &function_exported?(&1, :start_link, 0),
                         &(worker(&1, [])))

    opts = [strategy: :one_for_one, name: BuildyPush.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BuildyPush.Endpoint.config_change(changed, removed)
    :ok
  end
end
