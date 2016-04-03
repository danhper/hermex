defmodule BuildyPush.MessageWorker.RemoteTest do
  use BuildyPush.WorkerCase

  alias BuildyPush.MessageWorker.Remote

  setup do
    topic = insert(:topic)
    app = insert(:gcm_app)
    devices = insert_list(5, :device, app_id: app.id)
    subscriptions = Enum.map(devices, &insert(:subscription, device_id: &1.id, topic_id: topic.id))
    {:ok, [topic: topic, app: app, devices: devices, subscriptions: subscriptions]}
  end

  test "send_message", %{topic: topic} do
    notification = %{title: "Hello", body: "This is a notification"}
    message = insert(:message, topic_id: topic.id, data: notification, sender_key: "that-would-be-me")
    assert {:noreply, %{}} = Remote.handle_cast({:send_message, message}, %{})
  end
end
