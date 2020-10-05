defmodule Erm.Core.Actions.Locally.AddStore do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  @behaviour ActionImpl

  def run(%Application{} = application, data) do
    Entity.add_entity(application, :store, data)
  end
end
