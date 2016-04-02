defmodule BuildyPush.SubscriptionController do
  use BuildyPush.Web, :controller

  alias BuildyPush.Subscription

  plug :scrub_params, "subscription" when action in [:create]

  def index(conn, _params) do
    subscriptions = Repo.all(Subscription)
    render(conn, "index.json", subscriptions: subscriptions)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    Subscription.changeset(%Subscription{}, subscription_params)
    |> Repo.insert
    |> Utils.handle_save(conn, location: &subscription_path(conn, :show, &1))
  end

  def show(conn, %{"id" => id}) do
    subscription = Repo.get!(Subscription, id)
    render(conn, "show.json", subscription: subscription)
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Subscription, id)
    |> Repo.delete!
    send_resp(conn, :no_content, "")
  end
end
