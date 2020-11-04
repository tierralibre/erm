defmodule Erm.Core.Actions.Locally.AddStockTest do
  use ExUnit.Case

  alias Erm.Core.Actions.Locally.AddStore
  alias Erm.Core.Actions.Locally.AddProduct
  alias Erm.Core.Actions.Locally.AddStock

  alias Erm.Core.{Application, Relation}

  test "can add stock is added to the application" do
    data = %{name: "Gross Grocery"}
    {:ok, application1, %{entity: store}} = AddStore.run(Application.new("Application", []), data)

    data = %{name: "Rotten tomato"}
    {:ok, application2, %{entity: product}} = AddProduct.run(application1, data)

    product_uuid = product.uuid
    store_uuid = store.uuid
    data = %{"from" => product_uuid, "to" => store_uuid, "units" => 200, "price" => "20.34 EUR"}
    {:ok, application, %{}} = AddStock.run(application2, data)

    assert %Application{
             relations: [%Relation{type: :stock, from: product_uuid, to: store_uuid, data: data}]
           } = application
  end
end
