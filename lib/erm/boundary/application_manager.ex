defmodule Erm.Boundary.ApplicationManager do
  use GenServer

  alias Erm.Core.{Application, Action, Entity}

  def init(applications), do: {:ok, applications}

  def start_link(applications),
    do: GenServer.start_link(__MODULE__, applications, name: __MODULE__)

  def registered_applications do
    [
      Application.new(
        "Locally",
        [
          Action.new(:add_store, :internal, Erm.Core.Actions.Locally.AddStore),
          Action.new(
            :add_product_to_category,
            :internal,
            Erm.Core.Actions.Locally.AddProductToCategory
          ),
          Action.new(:add_product, :internal, Erm.Core.Actions.Locally.AddProduct),
          Action.new(:add_stock, :internal, Erm.Core.Actions.Locally.AddStock),
          Action.new(
            :add_product_category,
            :internal,
            Erm.Core.Actions.Locally.AddProductCategory
          ),
          Action.new(
            :remove_product_category,
            :internal,
            Erm.Core.Actions.Locally.RemoveProductCategory
          ),
          Action.new(:remove_product, :internal, Erm.Core.Actions.Locally.RemoveProduct),
          Action.new(:remove_store, :internal, Erm.Core.Actions.Locally.RemoveStore),
          Action.new(
            :remove_product_from_category,
            :internal,
            Erm.Core.Actions.Locally.RemoveProductFromCategory
          ),
          Action.new(:remove_stock, :internal, Erm.Core.Actions.Locally.RemoveStock),
          Action.new(:update_stock, :internal, Erm.Core.Actions.Locally.UpdateStock)
        ]
      )
    ]
  end

  def list_applications do
    GenServer.call(__MODULE__, :list_applications)
  end

  def run_action(app_name, action_name, params) do
    GenServer.call(__MODULE__, {:run_action, app_name, action_name, params})
  end

  def list_entities(app_name, type) do
    GenServer.call(__MODULE__, {:list_entities, app_name, type})
  end

  def handle_call(:list_applications, _from, applications),
    do: {:reply, applications, applications}

  def handle_call({:run_action, app_name, action_name, params}, _from, applications) do
    {:ok, application, to_return} =
      Application.run_action(applications, app_name, action_name, params)

    {:reply, to_return, insert_application(applications, application)}
  end

  def handle_call({:list_entities, app_name, type}, _from, applications) do
    Application.find_application(applications, app_name)
    |> Entity.list_entities(type)
  end

  defp insert_application(applications, application) do
    [application | Enum.filter(applications, fn ap -> ap.name == application.name end)]
  end
end
