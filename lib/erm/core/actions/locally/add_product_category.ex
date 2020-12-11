defmodule Erm.Core.Actions.Locally.AddProductCategory do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  @behaviour ActionImpl

  def run(%Application{} = application, data) do
    Entity.add_entity(application, "product_category", data)
  end
end
