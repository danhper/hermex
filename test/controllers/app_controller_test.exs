defmodule BuildyPush.AppControllerTest do
  use BuildyPush.ConnCase

  alias BuildyPush.App

  @invalid_attrs %{platform: "foobar"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), attrs: params_for(:gcm_app)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, app_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    app = insert(:gcm_app)
    conn = get conn, app_path(conn, :show, app)
    safe_auth_key = String.slice(app.settings["auth_key"], 0..10) <> "..."
    assert json_response(conn, 200)["data"] == %{
      "id"       => app.id,
      "platform" => app.platform,
      "name"     => app.name,
      "settings" => %{"auth_key" => safe_auth_key}}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, app_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, app_path(conn, :create), app: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(App, Map.take(attrs, [:name, :platform]))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, app_path(conn, :create), app: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, attrs: attrs} do
    app = insert(:gcm_app)
    conn = put conn, app_path(conn, :update, app), app: attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(App, Map.take(attrs, [:name, :platform]))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    app = insert(:gcm_app)
    conn = put conn, app_path(conn, :update, app), app: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    app = insert(:gcm_app)
    conn = delete conn, app_path(conn, :delete, app)
    assert response(conn, 204)
    refute Repo.get(App, app.id)
  end
end
