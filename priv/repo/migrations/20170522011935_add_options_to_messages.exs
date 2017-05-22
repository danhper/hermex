defmodule BuildyPush.Repo.Migrations.AddOptionsToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :options, :map
    end
  end
end
