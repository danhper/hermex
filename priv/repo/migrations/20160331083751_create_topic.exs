defmodule Hermex.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:topics, [:name])
  end
end
