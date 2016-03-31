defmodule BuildyPush.TopicView do
  use BuildyPush.Web, :view

  def render("index.json", %{topics: topics}) do
    %{data: render_many(topics, BuildyPush.TopicView, "topic.json")}
  end

  def render("show.json", %{topic: topic}) do
    %{data: render_one(topic, BuildyPush.TopicView, "topic.json")}
  end

  def render("topic.json", %{topic: topic}) do
    %{id: topic.id,
      name: topic.name}
  end
end
