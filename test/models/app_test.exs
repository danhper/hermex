defmodule Hermex.AppTest do
  use Hermex.ModelCase

  alias Hermex.App

  test "changeset with valid attributes" do
    changeset = App.changeset(%App{}, params_for(:gcm_app))
    assert changeset.valid?
  end

  test "changeset with invalid platform" do
    changeset = App.changeset(%App{}, params_for(:gcm_app, platform: "i-dont-exist"))
    refute changeset.valid?
  end

  test "changeset with missing settings" do
    changeset = App.changeset(%App{}, params_for(:gcm_app, settings: %{}))
    refute changeset.valid?
  end

  test "changeset with duplicate name/platform" do
    app = insert(:gcm_app)
    changeset = App.changeset(%App{}, params_for(:gcm_app, name: app.name))
    assert {:error, _} = Repo.insert(changeset)
  end
end
