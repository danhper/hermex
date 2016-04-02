defmodule BuildyPush.Subscription do
  use BuildyPush.Web, :model

  schema "subscriptions" do
    belongs_to :topic, BuildyPush.Topic
    belongs_to :device, BuildyPush.Device

    timestamps
  end

  @required_fields ~w(topic_id)
  @optional_fields ~w(device_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
