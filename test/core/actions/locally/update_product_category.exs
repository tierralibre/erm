defmodule Erm.Core.Actions.Locally.UpdateProductCategory do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.UpdateProductCategory

  test "update stock in the application" do
    data = %{stock: 30, whatever: "yeah"}
    {_store, _product, category, created_app} = create_locally_entities_and_relations()

    {:ok, application, %{}} = UpdateStore.run(created_app, %{uuid: category.uuid, data: data})

    assert length(application.entities) == 3
    [entity | _] = application.entities
    assert entity.type == :store
    assert entity.data == data
  end
end
