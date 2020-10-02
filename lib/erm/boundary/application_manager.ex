defmodule Erm.Boundary.ApplicationManager do
  use GenServer

  alias Erm.Core.{Application, Action}

  def init(applications), do: {:ok, applications}

  def start_link(applications), do: GenServer.start_link(__MODULE__, applications, name: __MODULE__)

  def registered_applications, do: [Application.new("Locally", [Action.new(:add_store, :internal, Erm.Core.Actions.Locally.AddStore)])]

  def get_applications do
    GenServer.call(__MODULE__, :get_applications)
  end

  @spec run_action(any, any, any) :: any
  def run_action(app_name, action_name, params) do
    GenServer.call(__MODULE__, {:run_action, app_name, action_name, params})
  end

  def handle_call(:get_applications, _from, applications), do: {:reply, applications, applications}

  def handle_call({:run_action, app_name, action_name, params}, _from, applications) do
    {:ok, application, to_return} = Application.run_action(applications, app_name, action_name, params)
    {:reply, to_return, insert_application(applications, application)}
  end

  defp insert_application(applications, application) do
    [application | Enum.filter(applications, fn ap -> ap.name == application.name end)]
  end
end
