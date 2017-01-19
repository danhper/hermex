defmodule BuildyPush.PushexAppManager do
  @behaviour Pushex.AppManager

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{apps: %{}}}
  end

  def find_app(platform, name) when platform in ~w(apns gcm)a do
    find_app(to_string(platform), name)
  end
  def find_app(platform, name) when platform in ~w(apns gcm) do
    case find_cached_app(platform, name) do
      nil ->
        fetch_app(platform, name)
      app ->
        app
    end
  end

  def find_cached_app(platform, name) do
    GenServer.call(__MODULE__, {:find_app, platform, name})
  end

  def cache_app(app) do
    GenServer.call(__MODULE__, {:cache_app, app})
  end

  def invalidate_app(app) do
    GenServer.call(__MODULE__, {:invalidate_app, app})
  end

  def handle_call({:find_app, platform, name}, _from, state) do
    case Map.get(state.apps, {platform, name}) do
      nil ->
        {:reply, nil, state}
      {app, expires_at} ->
        if Timex.compare(expires_at, Timex.now) == 1 do
          {:reply, app, state}
        else
          {:reply, nil, remove_app_from_state(state, app)}
        end
    end
  end

  def handle_call({:cache_app, app}, _from, state) do
    expires_at = Timex.shift(Timex.now, seconds: cache_timeout())
    apps = Map.put(state.apps, {app_platform(app), app.name}, {app, expires_at})
    {:reply, app, Map.put(state, :apps, apps)}
  end

  def handle_call({:invalidate_app, app}, _from, state) do
    {:reply, :ok, remove_app_from_state(state, app)}
  end

  defp remove_app_from_state(state, app) do
    apps = Map.delete(state.apps, {app_platform(app), app.name})
    Map.put(state, :apps, apps)
  end

  defp fetch_app(platform, name) do
    if app = BuildyPush.Repo.get_by(BuildyPush.App, platform: platform, name: name) do
      platform |> make_app(app) |> cache_app()
    end
  end

  defp make_app(platform, app) do
    attrs = Enum.map(app.settings, &transform_setting/1)
            |> Enum.into(%{name: app.name})
    struct(base_app(platform), attrs)
  end

  defp app_platform(%Pushex.APNS.App{}), do: "apns"
  defp app_platform(%Pushex.GCM.App{}), do: "gcm"
  defp app_platform(%BuildyPush.App{platform: platform}), do: platform

  defp transform_setting({"env", value}), do: {:env, String.to_atom(value)}
  defp transform_setting({key, value}), do: {String.to_atom(key), value}

  defp base_app("apns"), do: Pushex.APNS.App
  defp base_app("gcm"), do: Pushex.GCM.App

  defp cache_timeout() do
    Application.get_env(:buildy_push, __MODULE__)[:cache_timeout]
  end
end
