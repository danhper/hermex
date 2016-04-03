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
    message = BuildyPush.Repo.preload(message, [topic: [subscriptions: [device: :app]]])
    message.topic.subscriptions
    |> Enum.map(&(&1.device))
    |> Enum.group_by(&({&1.app.platform, &1.app.name}))
    |> Enum.each(fn {app, devices} -> send_messages(app, devices, message) end)

    {:noreply, state}
  end

  defp send_messages({platform, name}, devices, message) do
    to = Enum.map(devices, &(&1.token))
    Pushex.send_notification(message.data, to: to, using: String.to_atom(platform), with_app: name)
  end
end

