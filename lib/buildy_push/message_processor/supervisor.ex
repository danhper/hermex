defmodule Hermex.MessageProcessor.Supervisor do
  use Supervisor

  alias Hermex.MessageProcessor.Scheduler.Supervisor, as: SchedulerSupervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    message_worker = Application.get_env(:hermex, :message_worker_impl)

    children = [
      worker(message_worker, []),
      supervisor(SchedulerSupervisor, []),
      worker(Hermex.MessageProcessor.Dispatcher, [])
    ]

    opts = [strategy: :rest_for_one, name: Hermex.MessageProcessor.Supervisor]
    supervise(children, opts)
  end
end
