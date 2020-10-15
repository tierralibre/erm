defmodule Erm.Core.Actions.Locally.UpdateStockTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.UpdateStock

  test "update stock in the application" do
    data = %{stock: 30, whatever: "yeah"}
    {store, product, _category, created_app} = create_locally_entities_and_relations()

    {:ok, application, %{}} =
      UpdateStock.run(created_app, %{from: product.uuid, to: store.uuid, data: data})

    assert length(application.relations) == 2
    [relation | _] = application.relations
    assert relation.type == :stock
    assert relation.data == data
  end
end
