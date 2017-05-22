defmodule BuildyPush.MessageProcessor.Scheduler.Supervisor do
  use Supervisor

  alias BuildyPush.MessageProcessor.Scheduler.Worker, as: SchedulerWorker

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(SchedulerWorker, [], restart: :transient)
    ]

    opts = [strategy: :simple_one_for_one,
            max_restarts: 5,
            max_seconds: 60,
            name: BuildyPush.MessageProcessor.Scheduler.Supervisor]
    supervise(children, opts)
  end
end
