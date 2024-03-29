defmodule HermexWeb.TopicController do
  use HermexWeb, :controller

  alias Hermex.Push.Topic

  plug :scrub_params, "topic" when action in [:create]

  def index(conn, params) do
    topics = Repo.paginate(Topic, params)
    render(conn, "index.json", topics: topics)
  end

  def create(conn, %{"topic" => topic_params}) do
    Topic.changeset(%Topic{}, topic_params)
    |> Repo.insert
    |> Utils.handle_save(conn, location: &topic_path(conn, :show, &1))
  end

  def show(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id)
    render(conn, "show.json", topic: topic)
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id)
    |> Repo.delete!
    send_resp(conn, :no_content, "")
  end
end
