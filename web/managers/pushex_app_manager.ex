defmodule BuildyPush.PushexAppManager do
  @behaviour Pushex.AppManager

  def find_app(platform, name) when platform in [:gcm, "gcm"] do
    if app = BuildyPush.Repo.get_by(BuildyPush.App, platform: "gcm", name: name) do
      %Pushex.GCM.App{name: name, auth_key: app.settings["auth_key"]}
    end
  end
end
