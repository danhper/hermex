defmodule BuildyPush.MessageTest do
  use BuildyPush.ModelCase

  alias BuildyPush.Message

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{topic_id: 1}, params_for(:message))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
