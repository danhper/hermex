defmodule Hermex.Push.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :name, :string

    has_many :messages, Hermex.Push.Message
    has_many :subscriptions, Hermex.Push.Subscription

    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w()a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> validate_length(:name, min: 3, max: 100)
  end
end
