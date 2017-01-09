defmodule BuildyPush.MessageWorker do
  @callback send_message(message :: Buildy.Message) :: :ok

  def send_message(message) do
    impl().send_message(message)
  end

  defp impl() do
	  Application.get_env(:buildy_push, :message_worker_impl)
  end
end
