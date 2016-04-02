defmodule BuildyPush.SubscriptionTest do
  use BuildyPush.ModelCase

  alias BuildyPush.Subscription

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Subscription.changeset(%Subscription{}, params_for(:subscription))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Subscription.changeset(%Subscription{}, @invalid_attrs)
    refute changeset.valid?
  end
end
