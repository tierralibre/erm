defmodule Erm.Core.Action do
  defstruct [:name, :entities, :permissions, :type, :implementation, :url_call]

  def new(name, :internal, implementation) do
    %__MODULE__{
      name: name,
      entities: [],
      permissions: nil,
      type: :internal,
      implementation: implementation
    }
  end

  def new(name, :external, url_call) do
    %__MODULE__{
      name: name,
      entities: [],
      permissions: nil,
      type: :external,
      url_call: url_call
    }
  end

  def run_action(%__MODULE__{type: :internal, implementation: implementation}, application, params) do
    apply(implementation, :run, [application, params])
  end
end
