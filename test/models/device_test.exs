defmodule Hermex.DeviceTest do
  use Hermex.ModelCase

  alias Hermex.Device

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, params_for(:device))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with duplicate app_id/token" do
    device = insert(:device)
    changeset = Device.changeset(%Device{}, Map.take(device, [:token, :app_id]))
    assert {:error, _} = Repo.insert(changeset)
  end
end
