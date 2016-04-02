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

  test "changeset with duplicate topic_id/device_id" do
    subscription = insert(:subscription, device_id: insert(:device).id)
    changeset = Subscription.changeset(%Subscription{}, params_for(:subscription, device_id: subscription.device_id, topic_id: subscription.topic_id))
    assert {:error, _} = Repo.insert(changeset)
  end
end
