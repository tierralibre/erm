defmodule Erm.Core.Entity do
  defstruct [:type, :uuid, :owner, :permissions, :data, :valid_from, :valid_to]

  def new(%{type: type, data: data}) do
    %__MODULE__{
      type: type,
      uuid: UUID.uuid1(),
      owner: nil,
      permissions: nil,
      data: data,
      valid_from: DateTime.utc_now(),
      valid_to: nil
    }
  end
end
