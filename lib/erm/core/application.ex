defmodule Erm.Core.Application do
  alias Erm.Core.Action

  defstruct [:name, :actions, :persistence]

  def new(app_name, actions, persistence) do
    %__MODULE__{name: app_name, actions: actions, persistence: persistence}
  end

  def find_application(applications, app_name) do
    Enum.find(applications, fn app -> app.name == app_name end)
  end

  def find_action(%__MODULE__{actions: actions}, action_name) do
    Enum.find(actions, fn action -> action.name == action_name end)
  end

  def run_action(applications, app_name, action_name, params) do
    applications
    |> find_application(app_name)
    |> run_action(action_name, params)
  end

  def run_action(%__MODULE__{} = application, action_name, params) do
    application
    |> find_action(action_name)
    |> Action.run_action(application, params)
  end
end
