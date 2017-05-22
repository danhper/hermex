defmodule Hermex.MessageView do
  use Hermex.Web, :view

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, Hermex.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, Hermex.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      topic_id: message.topic_id,
      recipients_count: message.recipients_count,
      data: message.data,
      sender_key: message.sender_key}
  end
end
