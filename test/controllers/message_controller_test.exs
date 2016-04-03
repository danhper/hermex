defmodule BuildyPush.MessageControllerTest do
  use BuildyPush.ConnCase

  alias BuildyPush.Message

  setup %{conn: conn} do
    attrs = params_for(:message)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), attrs: attrs}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message = insert(:message)
    conn = get conn, message_path(conn, :show, message)
    assert json_response(conn, 200)["data"] == %{"id" => message.id,
      "topic_id" => message.topic_id,
      "total_count" => message.total_count,
      "success_count" => message.success_count,
      "data" => Poison.decode!(Poison.encode!(message.data)),
      "sender_key" => message.sender_key}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, message_path(conn, :create), message: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Message, Map.take(attrs, [:topic_id, :data]))
  end

  test "fails with 400 when topic_id not passed", %{conn: conn} do
    assert_raise BuildyPush.BadRequestException, fn ->
      post conn, message_path(conn, :create), message: %{}
    end
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    topic = insert(:topic)
    conn = post conn, message_path(conn, :create), message: %{topic_id: topic.id}
    assert json_response(conn, 422)["errors"] != %{}
  end
end
