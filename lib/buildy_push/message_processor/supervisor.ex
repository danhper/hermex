defmodule BuildyPush.MessageProcessor.Supervisor do
  use Supervisor

  alias BuildyPush.MessageProcessor.Scheduler.Supervisor, as: SchedulerSupervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    message_worker = Application.get_env(:buildy_push, :message_worker_impl)

    children = [
      worker(message_worker, []),
      supervisor(SchedulerSupervisor, []),
      worker(BuildyPush.MessageProcessor.Dispatcher, [])
    ]

    opts = [strategy: :rest_for_one, name: BuildyPush.MessageProcessor.Supervisor]
    supervise(children, opts)
  end
end
