defmodule Hermex.Repo.Migrations.CreateApp do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :platform, :string, null: false
      add :name, :string, null: false
      add :settings, :map

      timestamps()
    end

    create unique_index(:apps, [:name, :platform])
  end
end
