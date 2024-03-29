defmodule Hermex.Push.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    belongs_to :topic, Hermex.Push.Topic
    belongs_to :device, Hermex.Push.Device

    timestamps()
  end

  @required_fields ~w(topic_id device_id)a
  @optional_fields ~w()a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:topic_id, name: :subscriptions_topic_id_device_id_index)
  end
end
