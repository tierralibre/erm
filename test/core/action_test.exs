defmodule Erm.Core.ActionTest do
  use ExUnit.Case
  use CoreBuilders

  test "actions can be created" do
    assert %Action{name: :dumb_action, type: _internal} = dumb_action()
  end

  test "execution of action" do
    par = params()
    app = application()
    assert {:ok, app, par} == Action.run_action(dumb_action(), app, par)
  end
end
