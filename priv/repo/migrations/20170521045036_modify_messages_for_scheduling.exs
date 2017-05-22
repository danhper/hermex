defmodule Hermex.Repo.Migrations.ModifyMessagesForScheduling do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :scheduled_at, :utc_datetime
      add :sent_at, :utc_datetime
      remove :delivered_count
    end
    create index(:messages, [:scheduled_at])
  end
end
