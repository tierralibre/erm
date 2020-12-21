defmodule Erm.Boundary.Apps do
  alias Erm.Core.Action
  alias Erm.Core.Application

  def get_application(app_name) do
    case :ets.lookup(:erm_apps, app_name) do
      [] ->
        read_configuration() |> store_configuration_in_ets() |> Enum.find(&(&1.name == app_name))

      [{^app_name, app}] ->
        app
    end
  end

  def read_configuration() do
    conf_folder = Path.join(:code.priv_dir(:erm), "config")
    {:ok, files} = File.ls(conf_folder)

    Enum.map(files, fn file ->
      Path.join(conf_folder, file) |> read() |> Jason.decode!() |> from_conf_to_app()
    end)
  end

  def store_configuration_in_ets(apps) do
    Enum.each(apps, fn app -> :ets.insert(:erm_apps, {app.name, app}) end)
    apps
  end

  defp from_conf_to_app(conf) do
    Application.new(
      conf["app_name"],
      from_conf_to_actions(conf["actions"]),
      get_persistence(conf["app_name"])
    )
  end

  defp from_conf_to_actions(actions) do
    Enum.map(actions, &from_conf_to_action/1)
  end

  defp from_conf_to_action(%{"type" => "instructions"} = action) do
    Action.new(
      String.to_atom(action["name"]),
      :instructions,
      action["input"],
      action["instructions"],
      action["output"]
    )
  end

  defp from_conf_to_action(%{"type" => "internal"} = action) do
    Action.new(
      String.to_atom(action["name"]),
      :internal,
      String.to_atom(action["implementation"])
    )
  end

  defp read(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> "{}"
    end
  end

  def get_persistence(_app_name) do
    Erm.Persistence.Ecto
  end
end
