defmodule Erm.Repo.Migrations.AddH3FieldEntity do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    execute "CREATE EXTENSION IF NOT EXISTS h3"
    alter table("entities") do
      add :h3index, :h3index
    end
  end
end
