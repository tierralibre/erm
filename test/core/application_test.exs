defmodule Erm.Core.ApplicationTest do
  use ExUnit.Case
  use CoreBuilders

  @app_name "App name"

  test "new applications are created" do
    assert %Application{name: @app_name, entities: [], relations: [], actions: []} =
             Application.new(@app_name, [], Erm.Persistence.Dumb)
  end

  test "applications are found" do
    assert List.first(applications()) ==
             Application.find_application(applications(), "Pelikan inks")
  end

  test "action is found in application" do
    assert dumb_action() == Application.find_action(application(), :dumb_action)
  end

  test "action can be run" do
    app = application()
    par = params()
    assert {:ok, app, par} == Application.run_action(app, :dumb_action, par)
  end

  test "action can be run from applications" do
    app = application()
    par = params()

    assert {:ok, app, par} ==
             Application.run_action(applications(), "Pelikan inks", :dumb_action, par)
  end
end
