defmodule BuildyPush.PingController do
  use BuildyPush.Web, :controller

  def ping(conn, _params) do
    send_resp(conn, 200, "pong")
  end
end
