defmodule Banking.Transaction do
  @moduledoc """
  Client for transactions
  """
  import Helper

  def deposit(user, amount, currency) when amount > 0 and is_binary(currency) do
    case GenServer.whereis(String.to_atom(user)) do
      nil ->
        {:error, :user_does_not_exist}

      _ ->
        new_balance =
          GenServer.call(String.to_atom(user), %{:deposit => {currency, to_decimal(amount)}})

        case new_balance do
          :too_many_requests_to_user ->
            {:error, :too_many_requests_to_user}

          _ ->
            {:ok, new_balance}
        end
    end
  end

  def deposit(_, _, _), do: {:error, :wrong_arguments}

  def withdraw(user, amount, currency) when amount > 0 and is_binary(currency) do
    case GenServer.whereis(String.to_atom(user)) do
      nil ->
        {:error, :user_does_not_exist}

      _ ->
        new_balance =
          GenServer.call(String.to_atom(user), %{:withdraw => {currency, to_decimal(amount)}})

        case new_balance do
          :not_enough_money -> {:error, :not_enough_money}
          :too_many_requests_to_user -> {:error, :too_many_requests_to_user}
          _ -> {:ok, new_balance}
        end
    end
  end

  def withdraw(_, _, _), do: {:error, :wrong_arguments}

  def get_balance(user, currency) when is_binary(currency) and is_binary(user) do
    case GenServer.whereis(String.to_atom(user)) do
      nil ->
        {:error, :user_does_not_exist}

      _ ->
        balance = GenServer.call(String.to_atom(user), {:get_balance, currency})

        case balance do
          :too_many_requests_to_user ->
            {:error, :too_many_requests_to_user}

          _ ->
            {:ok, to_decimal(balance)}
        end
    end
  end

  def get_balance(_, _), do: {:error, :wrong_arguments}

  def send(from_user, to_user, amount, currency)
      when from_user != to_user and amount > 0 and is_binary(currency) and is_binary(from_user) and
             is_binary(to_user) do
    case {GenServer.whereis(String.to_atom(from_user)),
          GenServer.whereis(String.to_atom(to_user))} do
      {nil, _} ->
        {:error, :sender_does_not_exist}

      {_, nil} ->
        {:error, :receiver_does_not_exist}

      {_, _} ->
        both_balance =
          GenServer.call(String.to_atom(from_user), %{
            :send => {currency, to_decimal(amount)},
            :receiver => to_user
          })

        case both_balance do
          :not_enough_money ->
            {:error, :not_enough_money}

          :too_many_requests_to_sender ->
            {:error, :too_many_requests_to_sender}

          :too_many_requests_to_receiver ->
            {:error, :too_many_requests_to_receiver}

          _ ->
            {from_balance, to_balance} = both_balance
            {:ok, from_balance, to_balance}
        end
    end
  end

  def send(_, _, _, _), do: {:error, :wrong_arguments}
end
