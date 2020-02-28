defmodule Server.TransactionServer do
  use GenServer

  def start_link(user) do
    GenServer.start_link(__MODULE__, %{user: user}, name: user)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(%{:deposit => {currency, amount}}, _from, state) do
    state = Map.put_new(state, currency, amount)
    {:reply, state[currency], state}
  end

  def handle_call(%{:withdraw => {currency, amount}}, _from, state) do
    state = Map.put_new(state, currency, amount)
    {:reply, state[currency], state}
  end

  def handle_call({:get_balance, currency}, _from, state) do
    balance = Map.get(state, currency)
    {:reply, balance, state}
  end
end

