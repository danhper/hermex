defmodule BuildyPush.MessageWorker.Remote do
  use GenServer

  @behaviour BuildyPush.MessageWorker

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, {:send_message, message})
  end

  def handle_cast({:send_message, message}, state) do
    message = BuildyPush.Repo.preload(message, [topic: [subscriptions: :device]])
    {:noreply, state}
  end
end

