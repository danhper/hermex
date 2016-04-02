defmodule BuildyPush.SubscriptionControllerTest do
  use BuildyPush.ConnCase

  alias BuildyPush.Subscription

  @invalid_attrs %{}

  setup %{conn: conn} do
    device = insert(:device)
    attrs = Map.put(params_for(:subscription), :device_id, device.id)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), attrs: attrs}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, subscription_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    subscription = insert(:subscription, device_id: insert(:device).id)
    conn = get conn, subscription_path(conn, :show, subscription)
    assert json_response(conn, 200)["data"] == %{"id" => subscription.id,
      "topic_id" => subscription.topic_id,
      "device_id" => subscription.device_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, subscription_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, subscription_path(conn, :create), subscription: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Subscription, Map.take(attrs, [:device_id, :topic_id]))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, subscription_path(conn, :create), subscription: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    subscription = insert(:subscription)
    conn = delete conn, subscription_path(conn, :delete, subscription)
    assert response(conn, 204)
    refute Repo.get(Subscription, subscription.id)
  end
end
