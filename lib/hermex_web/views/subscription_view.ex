defmodule HermexWeb.SubscriptionView do
  use HermexWeb, :view

  def render("index.json", %{subscriptions: subscriptions}) do
    %{data: render_many(subscriptions, HermexWeb.SubscriptionView, "subscription.json")}
  end

  def render("show.json", %{subscription: subscription}) do
    %{data: render_one(subscription, HermexWeb.SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{id: subscription.id,
      topic_id: subscription.topic_id,
      device_id: subscription.device_id}
  end
end
