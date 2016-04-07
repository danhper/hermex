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

  test "allows to send app_name and platform instead of app_id", %{conn: conn, attrs: attrs} do
    app = Repo.get!(BuildyPush.App, attrs.app_id)
    attrs = attrs |> Map.delete(:app_id) |> Map.merge(%{app_name: app.name, platform: app.platform})
    conn = post conn, device_path(conn, :create), device: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Device, Map.take(attrs, [:token, :app_id]))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    params = Map.put(@invalid_attrs, :app_id, insert(:gcm_app).id)
    conn = post conn, device_path(conn, :create), device: params
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

  test "find with app_id and token", %{conn: conn} do
    device = insert(:device)
    device_id = device.id
    conn = get conn, device_path(conn, :find, app_id: device.app_id, token: device.token)
    assert %{"id" => ^device_id} = json_response(conn, 200)["data"]
  end

  test "find with app_name, platform and token", %{conn: conn} do
    app = insert(:gcm_app)
    device = insert(:device, app_id: app.id)
    device_id = device.id
    conn = get conn, device_path(conn, :find, app_name: app.name, platform: app.platform, token: device.token)
    assert %{"id" => ^device_id} = json_response(conn, 200)["data"]
  end

  test "find with bad arguments", %{conn: conn} do
    assert_raise Phoenix.ActionClauseError, fn ->
      get conn, device_path(conn, :find, app_name: "foo")
    end
  end
end
