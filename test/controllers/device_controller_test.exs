defmodule BuildyPush.DeviceControllerTest do
  use BuildyPush.ConnCase

  alias BuildyPush.Device
  @invalid_attrs %{token: ""}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), attrs: params_for(:device)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    device = insert(:device)
    conn = get conn, device_path(conn, :show, device)
    assert json_response(conn, 200)["data"] == %{"id" => device.id,
      "app_id" => device.app_id,
      "token" => device.token,
      "custom_data" => device.custom_data}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, device_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, device_path(conn, :create), device: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Device, Map.take(attrs, [:token, :app_id]))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, attrs: attrs} do
    device = insert(:device)
    conn = put conn, device_path(conn, :update, device), device: attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Device, Map.take(attrs, [:token, :app_id]))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    device = insert(:device)
    conn = put conn, device_path(conn, :update, device), device: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    device = insert(:device)
    conn = delete conn, device_path(conn, :delete, device)
    assert response(conn, 204)
    refute Repo.get(Device, device.id)
  end
end
