defmodule BuildyPush.BadRequestException do
  defexception [:message]
end

defimpl Plug.Exception, for: BuildyPush.BadRequestException do
  def status(_exception), do: 400
end
