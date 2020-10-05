defmodule Erm.Core.Actions.Locally.AddProductCategoryTest do
  use ExUnit.Case

  alias Erm.Core.Actions.Locally.AddProductCategory
  alias Erm.Core.{Application, Entity}

  test "product category is added to the application" do
    data = %{name: "Grocery"}
    {:ok, application, %{}} = AddProductCategory.run(Application.new("Application", []), data)
    assert %Application{entities: [%Entity{type: :product_category, data: data}]} = application
  end
end
