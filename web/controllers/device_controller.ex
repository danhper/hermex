defmodule Hermex.DeviceController do
  use Hermex.Web, :controller

  alias Hermex.Device

  plug :scrub_params, "device" when action in [:create, :update]

  def index(conn, params) do
    devices = Device |> Device.filter(params) |> Repo.paginate(params)
    render(conn, "index.json", devices: devices)
  end

  def create(conn, %{"device" => device_params}) do
    find_app(device_params)
    |> Ecto.build_assoc(:devices)
    |> Device.changeset(device_params)
    |> Repo.insert
    |> Utils.handle_save(conn, location: &device_path(conn, :show, &1))
  end

  def show(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)
    render(conn, "show.json", device: device)
  end

  def find(conn, %{"app_id" => app_id, "token" => token}) do
    device = Repo.get_by!(Device, app_id: app_id, token: token)
    render(conn, "show.json", device: device)
  end
  def find(conn, %{"app_name" => _app_name, "platform" => _platform, "token" => _token} = params) do
    params = Map.put(params, "app_id", find_app(params).id)
    find(conn, params)
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

  defp find_app(%{"app_id" => app_id}) do
    Repo.get!(Hermex.App, app_id)
  end
  defp find_app(%{"app_name" => app_name, "platform" => platform}) do
    Repo.get_by!(Hermex.App, name: app_name, platform: platform)
  end
  defp find_app(_), do: raise Hermex.BadRequestException, "need app_name and platform or app_id"
end
