defmodule Erm.Core.Entity do
  defstruct [:type, :uuid, :owner, :permissions, :data, :valid_from, :valid_to]
end
