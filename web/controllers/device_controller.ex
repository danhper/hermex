defmodule BuildyPush.DeviceController do
  use BuildyPush.Web, :controller

  alias BuildyPush.Device

  plug :scrub_params, "device" when action in [:create, :update]

  def index(conn, _params) do
    devices = Repo.all(Device)
    render(conn, "index.json", devices: devices)
  end

  def create(conn, %{"device" => device_params}) do
    Device.changeset(%Device{}, device_params)
    |> Repo.insert
    |> Utils.handle_save(conn, location: &device_path(conn, :show, &1))
  end

  def show(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)
    render(conn, "show.json", device: device)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    Repo.get!(Device, id)
    |> Device.changeset(device_params)
    |> Repo.update
    |> Utils.handle_save(conn)
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Device, id)
    |> Repo.delete!
    send_resp(conn, :no_content, "")
  end
end
