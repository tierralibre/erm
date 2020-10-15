defmodule Erm.Core.Actions.Locally.UpdateStoreTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.UpdateStore

  test "update stock in the application" do
    data = %{stock: 30, whatever: "yeah"}
    {store, _product, _category, created_app} = create_locally_entities_and_relations()

    {:ok, application, %{}} = UpdateStore.run(created_app, %{uuid: store.uuid, data: data})

    assert length(application.entities) == 3
    [entity | _] = application.entities
    assert entity.type == :store
    assert entity.data == data
  end
end
