defmodule Erm.Core.Actions.Locally.AddProduct do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  @behaviour ActionImpl

  def run(%Application{} = application, data) do
    Entity.add_entity(application, :product, data)
  end
end
