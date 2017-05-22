defmodule BuildyPush.MessageTest do
  use BuildyPush.ModelCase

  alias BuildyPush.Message

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{topic_id: 1}, :create, params_for(:message))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, :create, @invalid_attrs)
    refute changeset.valid?
  end

  test "pending query" do
    _normal_message = insert(:message)
    pending_message = insert(:message, scheduled_at: Timex.now())
    _sent_message = insert(:message, scheduled_at: Timex.now(), sent_at: Timex.now())
    pending_messages = BuildyPush.Repo.all(BuildyPush.Message.pending)
    assert Enum.map(pending_messages, &(&1.id)) == [pending_message.id]
  end
end
