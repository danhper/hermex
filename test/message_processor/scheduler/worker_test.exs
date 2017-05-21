defmodule BuildyPush.MessageProcessor.Scheduler.WorkerTest do
  use BuildyPush.WorkerCase

  alias BuildyPush.MessageProcessor.Scheduler.Worker, as: SchedulerWorker

  test "message with scheduled_at in past" do
    BuildyPush.MessageWorker.Dummy.request_notification(self())
    message = insert(:message, scheduled_at: Timex.shift(Timex.now(), seconds: -1))
    message_id = message.id
    assert {:error, :normal} = GenServer.start_link(SchedulerWorker, message)
    assert_received {:message_id, ^message_id}
  end

  test "message with scheduled_at in the future" do
    BuildyPush.MessageWorker.Dummy.request_notification(self())
    message = insert(:message, scheduled_at: Timex.shift(Timex.now(), milliseconds: 50))
    message_id = message.id
    assert {:ok, pid} = GenServer.start_link(SchedulerWorker, message)
    ref = Process.monitor(pid)
    assert Process.alive?(pid)
    refute_received {:message_id, ^message_id}
    assert_receive {:message_id, ^message_id}
    assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
  end
end
