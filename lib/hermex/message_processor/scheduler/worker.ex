defmodule Hermex.MessageProcessor.Scheduler.Worker do
  use GenServer

  def start_link(message) do
    GenServer.start_link(__MODULE__, message)
  end

  def init(message) do
    case compute_milliseconds_timeout(message) do
      n when n <= 0 ->
        do_send_message(message)
        {:stop, :normal}
      n ->
        {:ok, %{message: message}, n}
    end
  end

  def handle_info(:timeout, %{message: message} = state) do
    do_send_message(message)
    {:stop, :normal, state}
  end

  defp do_send_message(message) do
    Hermex.MessageProcessor.Worker.send_message(message)
  end

  defp compute_milliseconds_timeout(%Hermex.Push.Message{scheduled_at: scheduled_at}) do
    Timex.diff(scheduled_at, Timex.now(), :milliseconds)
  end
end
