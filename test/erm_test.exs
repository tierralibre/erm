defmodule ErmTest do
  use ExUnit.Case
  doctest Erm

  test "greets the world" do
    assert Erm.hello() == :world
  end
end
