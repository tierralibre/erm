defmodule Erm.Core.Actions.ActionImpl do
  @type input :: map
  @type output :: map
  @type error :: map

  @callback run(input) :: {:ok, output} | {:error, error}
end
