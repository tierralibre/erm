defmodule Erm.Boundary.ErmApi do
  alias Erm.Core.{Application, Entity, Relation}
  alias Erm.Boundary.Apps

  def run_action(app_name, action_name, params) do  
      case Apps.get_application(app_name) do
        nil -> 
          {:error, "The application #{app_name} is not registered"}
        app -> 
          Application.run_action(app, action_name, params)
      end
  end

  def run_action!(app_name, action_name, params) do
    case run_action(app_name, action_name, params) do
      {:ok, to_return} -> to_return
      {:error, message} -> raise message
    end
  end

  def list_entities(app_name, type, equality_field_values \\ []) do
    Entity.list_entities(app_name, Apps.get_persistence(app_name), type, equality_field_values)
  end

  def list_entities_by_relation(app_name, type, direction, id) do
    Entity.list_entities_by_relation(
      app_name,
      Apps.get_persistence(app_name),
      type,
      direction,
      id
    )
  end

  def get_entity(app_name, uuid) do
    Entity.get_entity(app_name, Apps.get_persistence(app_name), uuid)
  end

  def list_relations(app_name, type, %{} = properties) do
    Relation.list_relations(app_name, Apps.get_persistence(app_name), type, properties)
  end

  def get_relation(app_name, type, from, to) do
    Relation.get_relation(app_name, Apps.get_persistence(app_name), type, from, to)
  end
end
