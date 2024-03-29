defmodule HermexWeb.MessageController do
  use HermexWeb, :controller

  alias Hermex.Push.Message
  alias Hermex.MessageProcessor.Dispatcher, as: MessageDispatcher

  plug :scrub_params, "message" when action in [:create]

  def index(conn, params) do
    messages = Repo.paginate(Message, params)
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    topic = find_topic(message_params)
    message = Ecto.build_assoc(topic, :messages)
    Message.changeset(message, :create, message_params)
    |> Repo.insert
    |> case do
         {:ok, message} ->
           MessageDispatcher.process_message(message)
           Utils.render_saved(conn, message, location: &message_path(conn, :show, &1))
         {:error, changeset} ->
           Utils.render_unprocessable(conn, changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.json", message: message)
  end

  defp find_topic(%{"topic_id" => topic_id}), do: Repo.get!(Hermex.Push.Topic, topic_id)
  defp find_topic(%{"topic_name" => topic_name}), do: Repo.get_by!(Hermex.Push.Topic, name: topic_name)
  defp find_topic(_), do: raise HermexWeb.BadRequestException, "need topic_id or topic_name"
end
