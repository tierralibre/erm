defmodule Erm.Boundary.Apps do

  alias Erm.Core.Action

  def registered_actions do
    %{"Locally" => [
      Action.new(:add_store, :internal, Erm.Core.Actions.Locally.AddStore),
      Action.new(:update_store, :internal, Erm.Core.Actions.Locally.UpdateStore),
      Action.new(
        :add_product_to_category,
        :internal,
        Erm.Core.Actions.Locally.AddProductToCategory
      ),
      Action.new(:add_product, :internal, Erm.Core.Actions.Locally.AddProduct),
      Action.new(:add_stock, :internal, Erm.Core.Actions.Locally.AddStock),
      Action.new(
        :add_product_category,
        :internal,
        Erm.Core.Actions.Locally.AddProductCategory
      ),
      Action.new(
        :remove_product_category,
        :internal,
        Erm.Core.Actions.Locally.RemoveProductCategory
      ),
      Action.new(:remove_product, :internal, Erm.Core.Actions.Locally.RemoveProduct),
      Action.new(:remove_store, :internal, Erm.Core.Actions.Locally.RemoveStore),
      Action.new(
        :remove_product_from_category,
        :internal,
        Erm.Core.Actions.Locally.RemoveProductFromCategory
      ),
      Action.new(:remove_stock, :internal, Erm.Core.Actions.Locally.RemoveStock),
      Action.new(:update_stock, :internal, Erm.Core.Actions.Locally.UpdateStock)
    ]}
  end

  def get_actions(app_name) do
    Map.get(registered_actions(), app_name, [])
  end
end
