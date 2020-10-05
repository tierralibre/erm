defmodule Erm.Core.Relation do
  alias Erm.Core.Application

  defstruct [:type, :owner, :from, :to, :data, :valid_from, :valid_to]

  def new(%{type: type, from: from, to: to, data: data}) do
    %__MODULE__{
      type: type,
      from: from,
      to: to,
      owner: nil,
      data: data,
      valid_from: :os.system_time(:millisecond),
      valid_to: nil
    }
  end

  def add_relation(%Application{relations: relations} = application, from, to, type, data) do
    new_rel = new(%{type: type, from: from, to: to, data: data})
    {:ok, %Application{application | relations: relations ++ [new_rel]}, %{relation: new_rel}}
  end
end
