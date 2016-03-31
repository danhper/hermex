defmodule BuildyPush.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :app_id, :integer, null: false
      add :token, :string, null: false
      add :custom_data, :map

      timestamps
    end

    create index(:devices, [:app_id])
    create unique_index(:devices, [:app_id, :token])
  end
end
