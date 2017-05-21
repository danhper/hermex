defmodule BuildyPush.Message do
  use BuildyPush.Web, :model

  schema "messages" do
    field :data, :map
    field :recipients_count, :integer, default: 0
    field :delivered_count, :integer, default: 0
    field :sender_key, :string
    field :scheduled_at, :utc_datetime
    belongs_to :topic, BuildyPush.Topic

    timestamps()
  end

  @required_fields ~w(data)a
  @optional_fields ~w(sender_key)a

  def changeset(model, action, params) do
    model
    |> cast(params, @required_fields ++ optional_fields(action))
    |> validate_required(@required_fields)
  end

  defp optional_fields(:internal_update) do
    optional_fields(:all) ++ [:recipients_count, :delivered_count]
  end
  defp optional_fields(_), do: @optional_fields
end
