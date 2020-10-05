defmodule Erm.Core.Actions.Locally.AddProductTest do
  use ExUnit.Case

  alias Erm.Core.Actions.Locally.AddProduct
  alias Erm.Core.{Application, Entity}

  test "product is added to the application" do
    data = %{name: "happy tshirt"}
    {:ok, application, %{}} = AddProduct.run(Application.new("Application", []), data)
    assert %Application{entities: [%Entity{type: :product, data: data}]} = application
  end
end
