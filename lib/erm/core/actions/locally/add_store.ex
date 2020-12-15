defmodule Erm.Core.Actions.Locally.AddStore do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  @behaviour ActionImpl

  def run(%Application{} = application, %{"h3index" => h3index} = data) do
    Entity.add_entity(application, "store", data, h3index)
  end

  def run(%Application{} = application, data) do
    Entity.add_entity(application, "store", data)
  end
end
