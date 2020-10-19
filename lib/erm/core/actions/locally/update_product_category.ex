defmodule Erm.Core.Actions.Locally.UpdateProductCategory do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  @behaviour ActionImpl

  def run(%Application{} = application, %{uuid: uuid, data: data}) do
    Entity.update_entity(application, uuid, data)
  end
end
