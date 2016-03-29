defmodule BuildyPush.PageController do
  use BuildyPush.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
