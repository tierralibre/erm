defmodule Erm.Boundary.ApplicationManager do
  use GenServer

  alias Erm.Core.{Application, Entity, Relation}
  alias Erm.Boundary.Apps

  def init(applications), do: {:ok, applications}

  def start_link(applications),
    do: GenServer.start_link(__MODULE__, applications, name: __MODULE__)

  def registered_applications do
    {:ok , app} =
      Application.new("Locally", Apps.get_actions("Locally"), Erm.Persistence.Json)
      |> load()
    [
      app
    ]
  end

  defp load(application) do
    application.persistence.load_application(application)
  end

  def list_applications do
    GenServer.call(__MODULE__, :list_applications)
  end

  def run_action(app_name, action_name, params) do
    GenServer.call(__MODULE__, {:run_action, app_name, action_name, params})
  end

  def list_entities(app_name, type, equality_field_values \\ []) do
    GenServer.call(__MODULE__, {:list_entities, app_name, type, equality_field_values})
  end

  def list_entities_by_relation(app_name, type, direction, id) do
    GenServer.call(__MODULE__, {:list_entities_by_relation, app_name, type, direction, id})
  end

  def get_entity(app_name, uuid) do
    GenServer.call(__MODULE__, {:get_entity, app_name, uuid})
  end

  def list_relations(app_name, type, %{} = properties) do
    GenServer.call(__MODULE__, {:list_relations, app_name, type, properties})
  end

  def get_relation(app_name, from, to) do
    GenServer.call(__MODULE__, {:get_relation, app_name, from, to})
  end

  def reset_app(app_name) do
    GenServer.call(__MODULE__, {:reset_app, app_name})
  end

  def handle_call(:list_applications, _from, applications),
    do: {:reply, applications, applications}

  def handle_call({:run_action, app_name, action_name, params}, _from, applications) do
    {:ok, application, to_return} =
      Application.run_action(applications, app_name, action_name, params)

    {:reply, to_return, insert_application(applications, application)}
  end

  def handle_call({:list_entities, app_name, type, equality_field_values}, _from, applications) do
    entities =
      Application.find_application(applications, app_name)
      |> Entity.list_entities(type, equality_field_values)

    {:reply, entities, applications}
  end

  def handle_call(
        {:list_entities_by_relation, app_name, type, direction, id},
        _from,
        applications
      ) do
    entities =
      Application.find_application(applications, app_name)
      |> Entity.list_entities_by_relation(type, direction, id)

    {:reply, entities, applications}
  end

  def handle_call({:get_entity, app_name, uuid}, _from, applications) do
    entity =
      Application.find_application(applications, app_name)
      |> Entity.get_entity(uuid)

    {:reply, entity, applications}
  end

  def handle_call({:get_relation, app_name, from, to}, _from, applications) do
    relation =
      Application.find_application(applications, app_name)
      |> Relation.get_relation(from, to)

    {:reply, relation, applications}
  end

  def handle_call({:list_relations, app_name, type, properties}, _from, applications) do
    relations =
      Application.find_application(applications, app_name)
      |> Relation.list_relations(type, properties)

    {:reply, relations, applications}
  end

  def handle_call({:reset_app, app_name}, _from, applications) do
    {:reply, :ok,
     insert_application(
       applications,
       Application.new(app_name, Apps.get_actions(app_name), Erm.Persistence.Json)
     )}
  end

  defp insert_application(applications, application) do
    [application | Enum.filter(applications, fn ap -> ap.name == application.name end)]
  end
end
