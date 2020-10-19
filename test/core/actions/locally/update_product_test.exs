defmodule Erm.Core.Actions.Locally.UpdateProductTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.UpdateProduct

  test "update product in the application" do
    data = %{stock: 30, whatever: "yeah"}
    {_store, product, _category, created_app} = create_locally_entities_and_relations()

    {:ok, application, %{}} = UpdateProduct.run(created_app, %{uuid: product.uuid, data: data})

    assert length(application.entities) == 3
    [entity | _] = application.entities
    assert entity.type == :product
    assert entity.data == data
  end
end
