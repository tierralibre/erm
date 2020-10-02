defmodule Erm.Core.Actions.ActionImpl do
  alias Erm.Core.Application

  @type input :: map
  @type output :: map
  @type error :: map
  @type application :: %Application{}

  @callback run(application, input) :: {:ok, application, output} | {:error, error}
end
