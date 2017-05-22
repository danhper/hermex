defmodule Hermex.AppView do
  use Hermex.Web, :view

  def render("index.json", %{apps: apps_paginator}) do
    render_many_with_metadata(apps_paginator, __MODULE__, "app.json")
  end

  def render("show.json", %{app: app}) do
    %{data: render_one(app, __MODULE__, "app.json")}
  end

  def render("app.json", %{app: app}) do
    %{id: app.id,
      platform: app.platform,
      name: app.name,
      settings: app.settings}
  end
end
