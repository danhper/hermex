defmodule HermexWeb.TopicView do
  use HermexWeb, :view

  def render("index.json", %{topics: topics}) do
    %{data: render_many(topics, HermexWeb.TopicView, "topic.json")}
  end

  def render("show.json", %{topic: topic}) do
    %{data: render_one(topic, HermexWeb.TopicView, "topic.json")}
  end

  def render("topic.json", %{topic: topic}) do
    %{id: topic.id,
      name: topic.name}
  end
end
