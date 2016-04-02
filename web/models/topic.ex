defmodule BuildyPush.Topic do
  use BuildyPush.Web, :model

  schema "topics" do
    field :name, :string

    has_many :messages, BuildyPush.Message
    has_many :subcriptions, BuildyPush.Subscription

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
    |> validate_length(:name, min: 3, max: 100)
  end
end
