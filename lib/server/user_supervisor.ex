defmodule Server.UserSupervisor do
  @moduledoc """
  DynamicSupervisor for user processes
  """
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(name) do
    DynamicSupervisor.start_child(__MODULE__, {Server.TransactionServer, String.to_atom(name)})
  end
end
