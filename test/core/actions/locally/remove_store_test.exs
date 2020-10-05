defmodule Erm.Core.Actions.Locally.RemoveStoreTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Actions.Locally.RemoveStore

  test "remove product in the application" do
    {store, _product, _category, created_app} = create_locally_entities()
    {:ok, application, %{}} = RemoveStore.run(created_app, %{uuid: store.uuid})
    assert length(application.entities) == 2
  end
end
