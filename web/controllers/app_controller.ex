defmodule BuildyPush.AppController do
  use BuildyPush.Web, :controller

  alias BuildyPush.App

  plug :scrub_params, "app" when action in ~w(create update)a

  def index(conn, _params) do
    apps = Repo.all(App)
    render(conn, "index.json", apps: apps)
  end

  def create(conn, %{"app" => app_params}) do
    App.changeset(%App{}, app_params)
    |> Repo.insert
    |> Utils.handle_save(conn, location: &app_path(conn, :show, &1), status: :created)
  end

  def show(conn, %{"id" => id}) do
    app = Repo.get!(App, id)
    render(conn, "show.json", app: app)
  end

  def find(conn, %{"platform" => platform, "name" => name}) do
    app = Repo.get_by!(App, platform: platform, name: name)
    render(conn, "show.json", app: app)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    Repo.get!(App, id)
    |> App.changeset(app_params)
    |> Repo.update
    |> Utils.handle_save(conn)
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(App, id)
    |> Repo.delete!
    send_resp(conn, :no_content, "")
  end
end
