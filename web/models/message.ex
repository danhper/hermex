defmodule Hermex.Message do
  use Hermex.Web, :model

  schema "messages" do
    field :data, :map
    field :recipients_count, :integer, default: 0
    field :sender_key, :string
    field :sent_at, :utc_datetime
    field :scheduled_at, :utc_datetime
    field :options, :map, default: %{}
    belongs_to :topic, Hermex.Topic

    timestamps()
  end

  @required_fields ~w(data)a
  @optional_fields ~w(sender_key options scheduled_at)a

  def changeset(model, action, params) do
    model
    |> cast(params, @required_fields ++ optional_fields(action))
    |> validate_required(@required_fields)
  end

  defp optional_fields(:internal_update) do
    optional_fields(:all) ++ ~w(recipients_count sent_at)a
  end
  defp optional_fields(_), do: @optional_fields

  def pending(query \\ __MODULE__) do
    from m in query,
      where: is_nil(m.sent_at) and not is_nil(m.scheduled_at)
  end
end
