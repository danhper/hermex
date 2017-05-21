defmodule BuildyPush.MessageProcessor.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    message_worker = Application.get_env(:buildy_push, :message_worker_impl)

    children = [
      worker(BuildyPush.MessageProcessor.Dispatcher, []),
      worker(message_worker, [])
    ]

    opts = [strategy: :one_for_one, name: BuildyPush.MessageProcessor.Supervisor]
    supervise(children, opts)
  end
end
