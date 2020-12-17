defmodule Erm.Persistence.Ecto do
  alias Erm.Persistence
  alias Erm.Persistence.Entity
  alias Erm.Persistence.Relation
  alias Erm.Repo
  import Ecto.Query

  @behaviour Persistence

  def save_entity(app_name, entity, repo\\Repo)
  def save_entity(app_name, %{id: nil} = entity, repo) do
    insert =
      entity
      |> Map.put(:app, app_name)
      |> Entity.new()
      |> repo.insert()

    case insert do
      {:ok, ent} -> {:ok, Entity.to_core_entity(ent)}
      _ -> :error
    end
  end

  def save_entity(_app_name, %{id: uuid} = entity, repo) do
    update =
      repo.get(Entity, uuid)
      |> Entity.changeset(entity)
      |> repo.update()

    case update do
      {:ok, ent} -> {:ok, Entity.to_core_entity(ent)}
      _ -> :error
    end
  end

  def save_relation(app_name, %Erm.Core.Relation{from: from, to: to, type: type} = relation, repo\\Repo) do
    persisted_entity = Repo.get_by(Relation, app: app_name, from: from, to: to, type: type)

    saved_entity =
      case persisted_entity do
        nil ->
          %Relation{app: app_name}
          |> Relation.changeset(relation |> Map.from_struct())
          |> repo.insert()

        _ ->
          persisted_entity
          |> Relation.changeset(relation |> Map.from_struct())
          |> repo.update()
      end

    case saved_entity do
      {:ok, _ent} -> {:ok, relation}
      _whatever -> :error
    end
  end

  def remove_entity(_app_name, uuid, repo\\Repo) do
    entity = repo.get(Entity, uuid)

    case entity do
      nil ->
        :error

      _ ->
        entity |> repo.delete()
        {:ok, Entity.to_core_entity(entity)}
    end
  end

  def remove_relation(app_name, type, from, to, repo\\Repo) do
    rel = repo.get_by(Relation, app: app_name, from: from, to: to, type: type)

    case rel do
      nil ->
        :error

      _ ->
        rel |> repo.delete()
        {:ok, Relation.to_core_relation(rel)}
    end
  end

  def load_application(%Erm.Core.Application{} = application) do
    {:ok, application}
  end

  def list_relations(app_name, type, %{from: from, to: to}) do
    Relation
    |> where([r], r.app == ^app_name and r.from == ^from and r.to == ^to and r.type == ^type)
    |> Repo.all()
    |> Enum.map(&Relation.to_core_relation/1)
  end

  def list_relations(app_name, type, %{from: from}) do
    Relation
    |> where([r], r.app == ^app_name and r.from == ^from and r.type == ^type)
    |> Repo.all()
    |> Enum.map(&Relation.to_core_relation/1)
  end

  def list_relations(app_name, type, %{to: to}) do
    Relation
    |> where([r], r.app == ^app_name and r.to == ^to and r.type == ^type)
    |> Repo.all()
    |> Enum.map(&Relation.to_core_relation/1)
  end

  def list_relations(app_name, type, %{}) do
    Relation
    |> where([r], r.app == ^app_name and r.type == ^type)
    |> Repo.all()
    |> Enum.map(&Relation.to_core_relation/1)
  end

  def get_relation(app_name, type, from, to) do
    Repo.get_by(Relation, app: app_name, from: from, to: to, type: type)
    |> Relation.to_core_relation()
  end

  def list_entities(app_name, type, equality_field_values \\ []) do
    Entity
    |> where(app: ^app_name, type: ^type)
    |> apply_field_values(equality_field_values)
    |> Repo.all()
    |> Enum.map(&Entity.to_core_entity/1)
  end

  defp apply_field_values(query, efv) do
    Enum.reduce(efv, query, fn {field, val}, query ->
      where(query, fragment("\"data\"->>? = ?", ^field, ^val))
    end)
  end

  def list_entities_by_relation(app_name, relation_type, :from, to) do
    ids =
      list_relations(app_name, relation_type, %{to: to})
      |> Enum.map(fn relation -> relation.from end)

    Entity
    |> where([e], e.id in ^ids)
    |> Repo.all()
    |> Enum.map(&Entity.to_core_entity/1)
  end

  def list_entities_by_relation(app_name, relation_type, :to, from) do
    ids =
      list_relations(app_name, relation_type, %{from: from})
      |> Enum.map(fn relation -> relation.to end)

    Entity
    |> where([e], e.id in ^ids)
    |> Repo.all()
    |> Enum.map(&Entity.to_core_entity/1)
  end

  def get_entity(_app, uuid) do
    Repo.get(Entity, uuid)
    |> Entity.to_core_entity()
  end
end
