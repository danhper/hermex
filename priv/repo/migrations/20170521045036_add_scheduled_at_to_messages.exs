defmodule BuildyPush.Repo.Migrations.AddScheduledAtToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :scheduled_at, :utc_datetime
    end
    create index(:messages, [:scheduled_at])
  end
end
