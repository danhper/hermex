defmodule Hermex.BadRequestException do
  defexception [:message]
end

defimpl Plug.Exception, for: Hermex.BadRequestException do
  def status(_exception), do: 400
end
