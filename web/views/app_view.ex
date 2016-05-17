defmodule BuildyPush.AppView do
  use BuildyPush.Web, :view

  def render("index.json", %{app: app}) do
    %{data: render_many(app, BuildyPush.AppView, "app.json")}
  end

  def render("show.json", %{app: app}) do
    %{data: render_one(app, BuildyPush.AppView, "app.json")}
  end

  def render("app.json", %{app: app}) do
    %{id: app.id,
      platform: app.platform,
      name: app.name,
      settings: render_settings(app.settings)}
  end

  defp render_settings(settings) do
    Enum.map(settings, fn {k, v} ->
      if k in BuildyPush.App.sensible_settings do
        {k, "#{String.slice(v, 0..10)}..."}
      else
        {k, v}
      end
    end)
    |> Enum.into(%{})
  end
end
