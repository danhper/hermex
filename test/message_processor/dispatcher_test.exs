defmodule Hermex.MessageProcessor.DispatcherTest do
  use Hermex.WorkerCase

  alias Hermex.MessageProcessor.Dispatcher

  setup do
    Hermex.MessageWorker.Dummy.request_notification(self())
    :ok
  end

  test "process message without scheduled_at" do
    %{id: message_id} = message = insert(:message)
    Dispatcher.process_message(message)
    assert_receive {:message_id, ^message_id}
  end

  test "process message with scheduled_at in the past" do
    scheduled_at = Timex.shift(Timex.now(), milliseconds: -50)
    %{id: message_id} = message = insert(:message, scheduled_at: scheduled_at)
    Dispatcher.process_message(message)
    assert_receive {:message_id, ^message_id}
  end

  test "process message with scheduled_at in the near future" do
    scheduled_at = Timex.shift(Timex.now(), milliseconds: 50)
    %{id: message_id} = message = insert(:message, scheduled_at: scheduled_at)
    Dispatcher.process_message(message)
    assert_receive {:message_id, ^message_id}
  end

  test "send pending messages" do
    Ecto.Adapters.SQL.Sandbox.allow(Hermex.Repo, self(), Process.whereis(Dispatcher))
    _not_sent = [
      insert(:message),
      insert(:message, scheduled_at: Timex.now(), sent_at: Timex.now()),
      insert(:message, scheduled_at: Timex.shift(Timex.now(), seconds: 5))
    ]
    %{id: message_id} = insert(:message, scheduled_at: Timex.shift(Timex.now(), milliseconds: -50))
    GenServer.cast(Dispatcher, :send_pending_messages)
    assert_receive {:message_id, ^message_id}
  end
end
