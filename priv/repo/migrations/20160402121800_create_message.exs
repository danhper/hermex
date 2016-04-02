defmodule BuildyPush.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :total_count, :integer, null: false, default: 0
      add :success_count, :integer, null: false, default: 0
      add :data, :map, null: false
      add :sender_key, :string
      add :topic_id, references(:topics), null: false

      timestamps
    end

    create index(:messages, [:topic_id])
    create index(:messages, [:sender_key])
  end
end
