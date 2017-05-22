defmodule BuildyPush.MessageProcessor.Scheduler.Worker do
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
    BuildyPush.MessageProcessor.Worker.send_message(message)
  end

  defp compute_milliseconds_timeout(%BuildyPush.Message{scheduled_at: scheduled_at}) do
    scheduled_at
    |> Timex.diff(Timex.now())
    |> Integer.floor_div(1000)
  end
end
