defmodule Erm.Core.ApplicationTest do
  use ExUnit.Case

  alias Erm.Core.Application

  @app_name "App name"

  test "new applications are created" do
    assert %Application{name: @app_name, entities: [], relations: [], actions: []} = Application.new(@app_name)
  end

end
