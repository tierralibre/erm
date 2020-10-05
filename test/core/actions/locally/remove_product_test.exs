defmodule Erm.Core.Actions.Locally.RemoveProductTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.RemoveProduct

  test "remove product in the application" do
    {_store, product, _category, created_app} = create_locally_entities()
    {:ok, application, %{}} = RemoveProduct.run(created_app, %{uuid: product.uuid})
    assert length(application.entities) == 2
  end
end
