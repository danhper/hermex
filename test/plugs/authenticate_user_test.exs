defmodule BuildyPush.Plug.AuthenticateUserTest do
  require Logger

  use BuildyPush.ConnCase

  alias BuildyPush.Plug.AuthenticateUser
  alias BuildyPush.Util.JWT

  @secret "foobar"

  test "init/1" do
    assert AuthenticateUser.init(secret: @secret).secret == @secret

    assert AuthenticateUser.init([]).secret == "secret"
  end

  test "call/2 with no Authorization header", %{conn: conn} do
    conn =
      Plug.Conn.delete_req_header(conn, "authorization")
      |> AuthenticateUser.call(%{secret: @secret})
    assert json_response(conn, 401)["error"] == "not authorized"
  end

  test "call/2 with malformed Authorization header", %{conn: conn} do
    conn =
      Plug.Conn.put_req_header(conn, "authorization", "foobar")
      |> AuthenticateUser.call(%{secret: @secret})
    assert json_response(conn, 401)["error"] == "not authorized"
  end

  test "call/2 with malformed Authorization token", %{conn: conn} do
    level = Logger.level
    Logger.configure(level: :error)
    conn =
      Plug.Conn.put_req_header(conn, "authorization", "Bearer foobar")
      |> AuthenticateUser.call(%{secret: @secret})
    assert json_response(conn, 401)["error"] == "not authorized"
    Logger.configure(level: level)
  end

  test "call/2 with invalid Authorization token", %{conn: conn} do
    token = JWT.make_token(%{"iss" => "someapp"}, "very-bad-secret")
    conn =
      Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
      |> AuthenticateUser.call(%{secret: @secret})
    assert json_response(conn, 401)["error"] == "not authorized"
  end

  test "call/2 with valid token", %{conn: conn} do
    token = JWT.make_token(%{"iss" => "someapp", "sub" => "someone"}, @secret)
    conn =
      Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
      |> AuthenticateUser.call(%{secret: @secret})
    refute conn.status == 401
    assert conn.assigns[:iss] == "someapp"
    assert conn.assigns[:sub] == "someone"
  end

  test "call/2 should add logger metadata", %{conn: conn} do
    token = JWT.make_token(%{"iss" => "someapp", "sub" => "someone"}, @secret)
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
    |> AuthenticateUser.call(%{secret: @secret})

    assert Logger.metadata[:iss] == "someapp"
    assert Logger.metadata[:sub] == "someone"
  end
end
