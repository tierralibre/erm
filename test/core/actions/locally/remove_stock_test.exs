defmodule Erm.Core.Actions.Locally.RemoveStockTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.RemoveStock

  test "remove stock in the application" do
    {store, product, _category, created_app} = create_locally_entities_and_relations()
    {:ok, application, %{}} = RemoveStock.run(created_app, %{from: product.uuid, to: store.uuid})
    assert length(application.relations) == 1
    [relation] = application.relations
    assert relation.type == :belongs_category
  end
end
