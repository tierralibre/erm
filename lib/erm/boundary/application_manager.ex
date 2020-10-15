defmodule Erm.Boundary.ApplicationManager do
  use GenServer

  alias Erm.Core.{Application, Entity}
  alias Erm.Boundary.Apps

  def init(applications), do: {:ok, applications}

  def start_link(applications),
    do: GenServer.start_link(__MODULE__, applications, name: __MODULE__)

  def registered_applications do
    [
      Application.new("Locally", Apps.get_actions("Locally"))
    ]
  end

  def list_applications do
    GenServer.call(__MODULE__, :list_applications)
  end

  def run_action(app_name, action_name, params) do
    GenServer.call(__MODULE__, {:run_action, app_name, action_name, params})
  end

  def list_entities(app_name, type) do
    GenServer.call(__MODULE__, {:list_entities, app_name, type})
  end

  def get_entity(app_name, uuid) do
    GenServer.call(__MODULE__, {:get_entity, app_name, uuid})
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

  def handle_call({:list_entities, app_name, type}, _from, applications) do
    entities =
      Application.find_application(applications, app_name)
      |> Entity.list_entities(type)

    {:reply, entities, applications}
  end

  def handle_call({:get_entity, app_name, uuid}, _from, applications) do
    entity =
      Application.find_application(applications, app_name)
      |> Entity.get_entity(uuid)

    {:reply, entity, applications}
  end

  def handle_call({:reset_app, app_name}, _from, applications) do
    {:reply, :ok,
      insert_application(
        applications,
        Application.new(app_name,  Apps.get_actions(app_name) )
      )
    }
  end

  defp insert_application(applications, application) do
    [application | Enum.filter(applications, fn ap -> ap.name == application.name end)]
  end
end
