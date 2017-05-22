defmodule Hermex.TopicControllerTest do
  use Hermex.ConnCase

  alias Hermex.Topic
  @invalid_attrs %{name: "a"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), attrs: params_for(:topic)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, topic_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    topic = insert(:topic)
    conn = get conn, topic_path(conn, :show, topic)
    assert json_response(conn, 200)["data"] == %{"id" => topic.id,
      "name" => topic.name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, topic_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, topic_path(conn, :create), topic: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Topic, Map.take(attrs, [:name]))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, topic_path(conn, :create), topic: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    topic = insert(:topic)
    conn = delete conn, topic_path(conn, :delete, topic)
    assert response(conn, 204)
    refute Repo.get(Topic, topic.id)
  end
end
