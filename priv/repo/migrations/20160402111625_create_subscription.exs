defmodule BuildyPush.Repo.Migrations.CreateSubscription do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :topic_id, references(:topics, on_delete: :delete_all), null: false
      add :device_id, references(:devices, on_delete: :delete_all)

      timestamps
    end
    create index(:subscriptions, [:topic_id])
    create index(:subscriptions, [:device_id])
    create unique_index(:subscriptions, [:topic_id, :device_id])
  end
end
