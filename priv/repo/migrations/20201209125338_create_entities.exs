defmodule Erm.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :app, :string
      add :type, :string
      add :data, :map
    end
  end
end
