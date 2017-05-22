defmodule BuildyPush.MessageWorker.Dummy do
  use GenServer

  @behaviour BuildyPush.MessageProcessor.Worker

  def start_link do
    GenServer.start_link(__MODULE__, %{watcher: nil}, name: __MODULE__)
  end

  def send_message(message) do
    GenServer.call(__MODULE__, {:send_message, message})
  end

  def request_notification(pid) do
    GenServer.call(__MODULE__, {:request_notification, pid})
  end

  def handle_call({:request_notification, pid}, _ref, state) do
    {:reply, :ok, Map.put(state, :watcher, pid)}
  end

  def handle_call({:send_message, message}, _ref, state) do
    if watcher = state[:watcher] do
      send(watcher, {:message_id, message.id})
    end
    {:reply, :ok, state}
  end
end
