defmodule BuildyPush.SubscriptionController do
  use BuildyPush.Web, :controller

  alias BuildyPush.Subscription

  plug :scrub_params, "subscription" when action in [:create]

  def index(conn, _params) do
    subscriptions = Repo.all(Subscription)
    render(conn, "index.json", subscriptions: subscriptions)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    topic = find_topic(subscription_params)
    device_id = Map.get(subscription_params, "device_id")
    subscription = device_id && Repo.get_by(Subscription, topic_id: topic.id, device_id: device_id)
    if subscription do
      Utils.render_saved(conn, subscription, status: :ok)
    else
      topic
      |> Ecto.build_assoc(:subscriptions)
      |> Subscription.changeset(subscription_params)
      |> Repo.insert
      |> Utils.handle_save(conn, location: &subscription_path(conn, :show, &1))
    end
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

  defp find_topic(%{"topic_id" => app_id}) do
    Repo.get!(BuildyPush.Topic, app_id)
  end
  defp find_topic(%{"topic_name" => topic_name}) do
    Repo.get_by!(BuildyPush.Topic, name: topic_name)
  end
  defp find_topic(_), do: raise BuildyPush.BadRequestException, "need topic_name or topic_id"
end
