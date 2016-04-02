defmodule BuildyPush.Message do
  use BuildyPush.Web, :model

  schema "messages" do
    field :total_count, :integer, default: 0
    field :success_count, :integer, default: 0
    field :data, :map
    field :sender_key, :string
    belongs_to :topic, BuildyPush.Topic

    timestamps
  end

  @required_fields ~w(data sender_key)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
