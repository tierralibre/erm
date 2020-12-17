defmodule Erm.Boundary.ErmApi do

  alias Erm.Core.{Application, Entity, Relation}
  alias Erm.Boundary.Apps

  def registered_applications do
    ["Locally"]
    |> Enum.map(fn app_name -> Application.new(app_name, Apps.get_actions(app_name), Apps.get_persistence(app_name)) |> load() end)
    |> Enum.map(fn {:ok, app} -> app end )
  end

  defp load(application) do
    application.persistence.load_application(application)
  end

  def list_applications do
    registered_applications()
  end

  def run_action(app_name, action_name, params) do
    {:ok, _application, to_return} =
      list_applications()
      |> Application.run_action(app_name, action_name, params)

    to_return
  end

  def list_entities(app_name, type, equality_field_values \\ []) do
    Entity.list_entities(app_name, Apps.get_persistence(app_name) ,type, equality_field_values)
  end

  def list_entities_by_relation(app_name, type, direction, id) do
    Entity.list_entities_by_relation(app_name, Apps.get_persistence(app_name), type, direction, id)
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
