defmodule Hermex.Subscription do
  use Hermex.Web, :model

  schema "subscriptions" do
    belongs_to :topic, Hermex.Topic
    belongs_to :device, Hermex.Device

    timestamps()
  end

  @required_fields ~w(topic_id device_id)a
  @optional_fields ~w()a

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:topic_id, name: :subscriptions_topic_id_device_id_index)
  end
end
