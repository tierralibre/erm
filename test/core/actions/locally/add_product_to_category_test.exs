defmodule Erm.Core.Actions.Locally.AddProductToCategoryTest do
  use ExUnit.Case

  alias Erm.Core.Actions.Locally.AddProductCategory
  alias Erm.Core.Actions.Locally.AddProduct
  alias Erm.Core.Actions.Locally.AddProductToCategory

  alias Erm.Core.{Application, Relation}

  test "can relate product and category is added to the application" do
    data = %{name: "happy tshirt"}

    {:ok, application1, %{entity: product}} =
      AddProduct.run(Application.new("Application", []), data)

    data = %{name: "Grocery"}
    {:ok, application2, %{entity: category}} = AddProductCategory.run(application1, data)

    product_uuid = product.uuid
    category_uuid = category.uuid
    data = %{from: product_uuid, to: category_uuid}
    {:ok, application, %{}} = AddProductToCategory.run(application2, data)

    assert %Application{
             relations: [
               %Relation{
                 type: :belongs_category,
                 from: product_uuid,
                 to: category_uuid,
                 data: data
               }
             ]
           } = application
  end
end
