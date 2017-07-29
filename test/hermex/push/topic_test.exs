defmodule Hermex.Push.TopicTest do
  use Hermex.ModelCase

  alias Hermex.Push.Topic

  @invalid_attrs [
    %{}, # name is required
    %{name: "a"}, # name is more than 3 chars
    %{name: String.duplicate("a", 101)} # name is less than 100 chars
  ]

  test "changeset with valid attributes" do
    changeset = Topic.changeset(%Topic{}, params_for(:topic))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    Enum.each @invalid_attrs, fn attrs ->
      changeset = Topic.changeset(%Topic{}, attrs)
      refute changeset.valid?
    end
  end

  test "topic name unique constraint" do
    topic = insert(:topic)
    changeset = Topic.changeset(%Topic{}, params_for(:topic, name: topic.name))
    assert {:error, _} = Repo.insert(changeset)
  end
end
