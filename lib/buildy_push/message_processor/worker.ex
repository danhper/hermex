defmodule Hermex.MessageProcessor.Worker do
  @callback send_message(message :: Hermex.Message) :: :ok

  def send_message(message) do
    impl().send_message(message)
  end

  defp impl() do
	  Application.get_env(:hermex, :message_worker_impl)
  end
end
