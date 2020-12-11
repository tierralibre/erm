defmodule Erm.Repo.Migrations.CreateRelations do
  use Ecto.Migration

  def change do
    create table(:relations, primary_key: false) do
      add :app, :string, primary_key: true
      add :type, :string, primary_key: true
      add :data, :map
      add :from, :string, primary_key: true
      add :to, :string, primary_key: true
    end
  end
end
