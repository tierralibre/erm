defmodule Erm.Core.Application do
  defstruct [:name, :entities, :relations, :actions]

  def new(app_name) do
    %__MODULE__{name: app_name, entities: [], relations: [], actions: []}
  end
end
