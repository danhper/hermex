defmodule BuildyPush.MessageController do
  use BuildyPush.Web, :controller

  alias BuildyPush.Message

  plug :scrub_params, "message" when action in [:create]

  def index(conn, _params) do
    messages = Repo.all(Message)
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    topic = find_topic(message_params)
    message = Ecto.build_assoc(topic, :messages)
    Message.changeset(message, message_params)
    |> Repo.insert
    |> case do
         {:ok, message} ->
           BuildyPush.MessageWorker.send_message(message)
           Utils.render_saved(conn, message, location: &message_path(conn, :show, &1))
         {:error, changeset} ->
           Utils.render_unprocessable(conn, changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.json", message: message)
  end

  defp find_topic(%{"topic_id" => topic_id}), do: Repo.get!(BuildyPush.Topic, topic_id)
  defp find_topic(%{"topic_name" => topic_name}), do: Repo.get_by!(BuildyPush.Topic, name: topic_name)
  defp find_topic(_), do: raise BuildyPush.BadRequestException, "need topic_id or topic_name"
end
