defmodule BuildyPush.MessageProcessor.Dispatcher do
  use GenServer

  alias BuildyPush.MessageProcessor.Worker

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def process_message(message) do
    GenServer.cast(__MODULE__, {:process_message, message})
  end

  def handle_cast({:process_message, message}, state) do
    do_process_message(message)
    {:noreply, state}
  end

  defp do_process_message(%BuildyPush.Message{scheduled_at: nil} = message) do
    Worker.send_message(message)
  end

  defp do_process_message(%BuildyPush.Message{scheduled_at: scheduled_at} = message) do
    case Timex.compare(Timex.now(), scheduled_at) do
      -1 ->
        :ok
      _ ->
        Worker.send_message(message)
    end
  end
end
