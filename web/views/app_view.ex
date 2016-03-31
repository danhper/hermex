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
      settings: app.settings}
  end
end
