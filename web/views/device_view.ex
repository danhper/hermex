defmodule Hermex.DeviceView do
  use Hermex.Web, :view

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, Hermex.DeviceView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, Hermex.DeviceView, "device.json")}
  end

  def render("device.json", %{device: device}) do
    %{id: device.id,
      app_id: device.app_id,
      custom_data: device.custom_data}
  end
end
