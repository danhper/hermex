defmodule Hermex.MessageProcessor.Worker.Remote do
  use GenServer

  @behaviour Hermex.MessageProcessor.Worker

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, {:send_message, message})
  end

  def handle_cast({:send_message, message}, state) do
    message = Hermex.Repo.preload(message, [topic: [subscriptions: [device: :app]]])
    subscriptions = message.topic.subscriptions

    subscriptions
    |> Enum.map(&(&1.device))
    |> Enum.group_by(&({&1.app.platform, &1.app.name}))
    |> Enum.each(fn {app, devices} -> send_messages(app, devices, message) end)

    update_message!(message, subscriptions)

    {:noreply, state}
  end

  defp send_messages({platform, app_name}, devices, message) do
    to = Enum.map(devices, &(&1.token))
    options = Keyword.merge(Keyword.new(message.options), [to: to, using: platform, with_app: app_name])
    Pushex.push(message.data, options)
  end

  defp update_message!(message, subscriptions) do
    params = %{recipients_count: length(subscriptions), sent_at: Timex.now()}
    changeset = Hermex.Message.changeset(message, :internal_update, params)
    Hermex.Repo.update!(changeset)
  end
end
