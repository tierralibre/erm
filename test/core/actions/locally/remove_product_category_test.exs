defmodule Erm.Core.Actions.Locally.RemoveProductCategoryTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.RemoveProductCategory

  test "remove product category to the application" do
    {_store, _product, category, created_app} = create_locally_entities()
    {:ok, application, %{}} = RemoveProductCategory.run(created_app, %{uuid: category.uuid})
    assert length(application.entities) == 2
  end
end
