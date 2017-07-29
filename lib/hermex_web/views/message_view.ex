defmodule HermexWeb.MessageView do
  use HermexWeb, :view

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, HermexWeb.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, HermexWeb.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      topic_id: message.topic_id,
      recipients_count: message.recipients_count,
      data: message.data,
      sender_key: message.sender_key}
  end
end
