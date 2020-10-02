defmodule Erm.Core.EntityTest do
  use ExUnit.Case

  alias Erm.Core.Entity


  test "new entities are created" do
    data = %{name: "Nostromo"}
    new_ent = Entity.new(%{type: :store, data: data})
    assert %Entity{data: data, type: :store} = new_ent
    assert is_binary(new_ent.uuid)
  end
end
