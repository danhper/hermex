defmodule HermexWeb.BadRequestException do
  defexception [:message]
end

defimpl Plug.Exception, for: HermexWeb.BadRequestException do
  def status(_exception), do: 400
end
