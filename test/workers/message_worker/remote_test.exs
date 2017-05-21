defmodule BuildyPush.MessageWorker.RemoteTest do
  use BuildyPush.WorkerCase

  alias BuildyPush.MessageProcessor.Worker.Remote

  setup do
    topic = insert(:topic)
    app = insert(:gcm_app)
    devices = insert_list(5, :device, app_id: app.id)
    subscriptions = Enum.map(devices, &insert(:subscription, device_id: &1.id, topic_id: topic.id))
    {:ok, [topic: topic, app: app, devices: devices, subscriptions: subscriptions]}
  end

  test "send_message", %{topic: topic} do
    body = "This is a notification"
    notification = %{title: "Hello", body: body}
    message = insert(:message, topic_id: topic.id, data: notification, sender_key: "that-would-be-me")
    assert {:noreply, %{}} = Remote.handle_cast({:send_message, message}, %{})
    assert Repo.get!(BuildyPush.Message, message.id).recipients_count == 5
    assert [{{:ok, res}, req, _}] = Pushex.Sandbox.wait_notifications
    assert req.notification.body == body
    assert res.success == 5
  end
end
