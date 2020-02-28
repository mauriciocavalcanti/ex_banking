defmodule Server.TransactionServer do
  use GenServer

  import Helper

  def start_link(user) do
    GenServer.start_link(__MODULE__, %{user: user}, name: user)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(%{:deposit => {currency, amount}}, _from, state) do
    current_balance = Map.get(state, currency, 0.0)
    new_balance = current_balance + amount
    state = Map.put(state, currency, new_balance)
    {:reply, new_balance, state}
  end

  def handle_call(%{:withdraw => {currency, amount}}, _from, state) do
    current_balance = Map.get(state, currency, 0.0)
    new_balance = current_balance - amount
    if new_balance <= 0 do
      {:reply, :not_enough_money, state}
    else
      state = Map.put(state, currency, new_balance)
      {:reply, new_balance, state}
    end
  end

  def handle_call({:get_balance, currency}, _from, state) do
    balance = Map.get(state, currency, 0.0)
    {:reply, balance, state}
  end

  def handle_call(%{:send => {currency, amount}, :receiver => to_user}, _from, state) do
    current_balance = Map.get(state, currency, 0.0)
    new_balance = current_balance - amount
    if new_balance <= 0 do
      {:reply, :not_enough_money, state}
    else
      receiver_balance = GenServer.call(String.to_atom(to_user), %{:receive => {currency, to_decimal(amount)}})
      case receiver_balance do
        :too_many_requests_to_receiver -> :too_many_requests_to_receiver
        _ ->
          state = Map.put(state, currency, new_balance)
          {:reply, {new_balance, receiver_balance}, state}
      end
    end
  end

  def handle_call(%{:receive => {currency, amount}}, _from, state) do
    current_balance = Map.get(state, currency, 0.0)
    new_balance = current_balance + amount
    state = Map.put(state, currency, new_balance)
    {:reply, new_balance, state}
  end
end

