defmodule Erm.Core.Actions.Locally.AddStoreTest do
  use ExUnit.Case

  alias Erm.Core.Actions.Locally.AddStore
  alias Erm.Core.{Application, Entity}

  test "store is added to the application" do
    data = %{name: "Nostromo"}
    {:ok, application, %{}} = AddStore.run(Application.new("Application", []), data)
    assert %Application{entities: [%Entity{type: :store, data: data}]} = application
  end
end
