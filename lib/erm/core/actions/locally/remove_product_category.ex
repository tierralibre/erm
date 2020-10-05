defmodule Erm.Core.Actions.Locally.RemoveProductCategory do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  @behaviour ActionImpl

  def run(%Application{} = application, %{uuid: uuid}) do
    Entity.remove_entity(application, uuid)
  end
end
