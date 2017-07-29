defmodule HermexWeb.PingController do
  use HermexWeb, :controller

  def ping(conn, _params) do
    send_resp(conn, 200, "pong")
  end
end
