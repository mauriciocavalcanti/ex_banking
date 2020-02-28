defmodule Banking.Transaction do
  import Helper

  def deposit(user, amount, currency) when amount > 0 and is_binary(currency) do
    case GenServer.whereis(String.to_atom(user)) do
      nil ->
        {:error, :user_does_not_exist}

      _ ->
        new_balance =
          GenServer.call(String.to_atom(user), %{:deposit => {currency, to_decimal(amount)}})

        {:ok, new_balance}
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
        {:ok, balance}
    end
  end

  def get_balance(_, _), do: {:error, :wrong_arguments}

  def send(from_user, to_user, amount, currency) do
  end
end
