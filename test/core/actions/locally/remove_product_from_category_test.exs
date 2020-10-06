defmodule Erm.Core.Actions.Locally.RemoveProductFromCategoryTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.RemoveProductFromCategory

  test "remove product from category" do
    {_store, product, category, created_app} = create_locally_entities_and_relations()

    {:ok, application, %{}} =
      RemoveProductFromCategory.run(created_app, %{from: product.uuid, to: category.uuid})

    assert length(application.relations) == 1
    [relation] = application.relations
    assert relation.type == :stock
  end
end
