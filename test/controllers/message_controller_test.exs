defmodule BuildyPush.MessageControllerTest do
  use BuildyPush.ConnCase

  alias BuildyPush.Message
  @valid_attrs %{data: %{}, sender_key: "some content", success_count: 42, total_count: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = get conn, message_path(conn, :show, message)
    assert json_response(conn, 200)["data"] == %{"id" => message.id,
      "topic_id" => message.topic_id,
      "total_count" => message.total_count,
      "success_count" => message.success_count,
      "data" => message.data,
      "sender_key" => message.sender_key}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
