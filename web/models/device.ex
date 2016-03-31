defmodule BuildyPush.Device do
  use BuildyPush.Web, :model

  schema "devices" do
    field :token, :string
    field :custom_data, :map

    belongs_to :app, BuildyPush.App

    timestamps
  end

  @required_fields ~w(app_id token)
  @optional_fields ~w(custom_data)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:token, name: :devices_app_id_token_index)
  end
end
