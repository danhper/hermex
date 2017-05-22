defmodule Hermex.PingController do
  use Hermex.Web, :controller

  def ping(conn, _params) do
    send_resp(conn, 200, "pong")
  end
end
