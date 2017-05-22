defmodule Hermex.MessageProcessor.Dispatcher do
  use GenServer

  alias Hermex.MessageProcessor.Worker
  alias Hermex.MessageProcessor.Scheduler

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init() do
    GenServer.cast(self(), :send_pending_messages)
    {:ok, %{}}
  end

  def process_message(message) do
    GenServer.cast(__MODULE__, {:process_message, message})
  end

  def handle_cast({:process_message, message}, state) do
    do_process_message(message)
    {:noreply, state}
  end

  def handle_cast(:send_pending_messages, state) do
    do_send_pending_messages()
    {:noreply, state}
  end

  defp do_send_pending_messages() do
    Hermex.Message.pending()
    |> Hermex.Repo.all()
    |> Enum.each(&do_process_message/1)
  end

  defp do_process_message(%Hermex.Message{scheduled_at: nil} = message) do
    Worker.send_message(message)
  end

  defp do_process_message(%Hermex.Message{scheduled_at: scheduled_at} = message) do
    case Timex.compare(Timex.now(), scheduled_at) do
      -1 ->
        Scheduler.send_message(message)
      _ ->
        Worker.send_message(message)
    end
  end
end
