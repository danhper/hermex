defmodule BuildyPush.PushexAppManagerTest do
  use BuildyPush.ModelCase

  alias BuildyPush.PushexAppManager

  test "find_app when app does not exist" do
    refute PushexAppManager.find_app(:gcm, "foo")
  end

  test "find_app gcm app when exists" do
    auth_key = "foobar"
    app = insert(:gcm_app, settings: %{auth_key: auth_key})
    assert %Pushex.GCM.App{} = fetched = PushexAppManager.find_app(:gcm, app.name)
    assert fetched.auth_key == auth_key
  end

  test "find_app apns app when exists" do
    cert = "BEGIN CERT blabla"
    app = insert(:apns_app, settings: %{cert: cert})
    assert %Pushex.APNS.App{} = fetched = PushexAppManager.find_app(:apns, app.name)
    assert fetched.cert == cert
  end

  test "find_app uses cache" do
    cert = "BEGIN CERT blabla"
    app = insert(:apns_app, settings: %{cert: cert})
    assert PushexAppManager.find_app(:apns, app.name)
    assert Repo.delete!(app)
    refute BuildyPush.Repo.get(BuildyPush.App, app.id)
    assert PushexAppManager.find_app(:apns, app.name)
  end

  test "find_app invalidates cache" do
    Application.put_env(:buildy_push, BuildyPush.PushexAppManager, [cache_timeout: 0])
    app = insert(:apns_app)
    assert PushexAppManager.find_app(:apns, app.name)
    assert Repo.delete!(app)
    refute BuildyPush.Repo.get(BuildyPush.App, app.id)
    refute PushexAppManager.find_app(:apns, app.name)
  after
    Application.put_env(:buildy_push, BuildyPush.PushexAppManager, [cache_timeout: 3600])
  end
end
