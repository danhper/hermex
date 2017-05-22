defmodule BuildyPush.MessageProcessor.Scheduler do
  alias BuildyPush.MessageProcessor.Scheduler.Supervisor, as: SchedulerSupervisor

  def send_message(message) do
    Supervisor.start_child(SchedulerSupervisor, [message])
  end
end
