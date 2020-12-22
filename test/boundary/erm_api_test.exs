defmodule Erm.Boundary.ApiTest do
  use ExUnit.Case

  alias Erm.Boundary.ErmApi
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Erm.Repo)
  end

  defmodule DumbAction do
    @behaviour ActionImpl

    def run(%Application{} = application, data) do
      {:ok, _app, ret} = Entity.add_entity(application, "dumb_thing", data)
      {:ok, ret}
    end
  end

  test "execute configured add action" do
    %{entity: entity} =
      ErmApi.run_action!("Locally_test", :add_store_test, %{
        "seller" => "928374923874",
        "store" => %{"name" => "nostromo"}
      })

    %{entity: e} =
      ErmApi.run_action!("Locally_test", :add_store_test, %{
        "seller" => "928374923874",
        "store" => %{"name" => "nostromo"}
      })

    assert entity.data["name"] == "nostromo"
    assert e.data["name"] == "nostromo"
  end

  test "execute internal action" do
    %{entity: entity} =
      ErmApi.run_action!("Locally_test", :dumb_internal_action, %{"name" => "nostromo"})

    %{entity: e} =
      ErmApi.run_action!("Locally_test", :dumb_internal_action, %{"name" => "nostromo"})

    assert entity.data["name"] == "nostromo"
    assert e.data["name"] == "nostromo"
  end

  test "execute internal update entity action" do
    %{entity: entity} =
      ErmApi.run_action!("Locally_test", :add_store_test, %{
        "seller" => "928374923874",
        "store" => %{"name" => "nostromo"}
      })

    %{entity: updated_entity} =
      ErmApi.run_action!("Locally_test", :update_store_test, %{
        "store_id" => entity.id,
        "store_update" => %{"name" => "patachula"}
      })

    assert updated_entity.data["name"] == "patachula"
  end

  test "execute internal update relation action" do
    %{relation: relation} =
      ErmApi.run_action!("Locally_test", :add_store_test, %{
        "seller" => "928374923874",
        "store" => %{"name" => "nostromo"}
      })

    %{relation: updated_relation} =
      ErmApi.run_action!("Locally_test", :update_ownership_test, %{
        "seller" => relation.from,
        "store" => relation.to,
        "rel_update" => %{"name" => "patachula"}
      })

    assert updated_relation.data["name"] == "patachula"
  end

  test "execute internal delete relation action" do
    %{relation: relation} =
      ErmApi.run_action!("Locally_test", :add_store_test, %{
        "seller" => "928374923874",
        "store" => %{"name" => "nostromo"}
      })

    %{relation: deleted_relation} =
      ErmApi.run_action!("Locally_test", :delete_ownership_test, %{
        "seller" => relation.from,
        "store" => relation.to
      })

    assert nil ==
             ErmApi.get_relation(
               "Locally_test",
               deleted_relation.type,
               deleted_relation.from,
               deleted_relation.to
             )
  end

  test "execute internal delete entity action" do
    %{entity: entity} =
      ErmApi.run_action!("Locally_test", :add_store_test, %{
        "seller" => "928374923874",
        "store" => %{"name" => "nostromo"}
      })

    %{entity: deleted_entity} =
      ErmApi.run_action!("Locally_test", :delete_store_test, %{"store" => entity.id})

    assert nil == ErmApi.get_entity("Locally_test", deleted_entity.id)
  end

  test "not registered app returns error" do
    error = ErmApi.run_action("Non existing app", :non_existing_action, %{})
    assert {:error, _message} = error
  end

  test "not registered app throws error" do
    assert_raise RuntimeError, fn ->
      ErmApi.run_action!("Non existing app", :non_existing_action, %{})
    end
  end

  test "not registered action returns error" do
    error = ErmApi.run_action("Locally_test", :non_existing_action, %{})
    assert {:error, _message} = error
  end
end
