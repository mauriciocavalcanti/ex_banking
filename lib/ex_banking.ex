defmodule ExBanking do
  @moduledoc """
  Simple banking OTP application in Elixir language.
  """

  alias Banking.{User, Transaction}

  @type banking_error ::
          {:error,
           :wrong_arguments
           | :user_already_exists
           | :user_does_not_exist
           | :not_enough_money
           | :sender_does_not_exist
           | :receiver_does_not_exist
           | :too_many_requests_to_user
           | :too_many_requests_to_sender
           | :too_many_requests_to_receiver}

  @doc """
  Function creates new user in the system
  New user has zero balance of any currency
  ### Examples

        iex> ExBanking.create_user("name")
        :ok

  """
  @spec create_user(user :: String.t()) :: :ok | banking_error
  defdelegate create_user(user), to: User

  @doc """
  Increases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  ### Examples

        iex> ExBanking.create_user("user to deposit")
        :ok
        iex> ExBanking.deposit("user to deposit", 1.22, "BRL")
        {:ok, 1.22}

  """
  @spec deposit(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | banking_error
  defdelegate deposit(user, amount, currency), to: Transaction

  @doc """
  Decreases user’s balance in given currency by amount value
  Returns new_balance of the user in given format
  ### Examples

        iex> ExBanking.create_user("user to withdraw")
        :ok
        iex> ExBanking.deposit("user to withdraw", 1.22, "BRL")
        {:ok, 1.22}
        iex> ExBanking.withdraw("user to withdraw", 1.22, "BRL")
        {:ok, 0.0}

  """
  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | banking_error
  defdelegate withdraw(user, amount, currency), to: Transaction

  @doc """
  Returns balance of the user in given format
  ### Examples

        iex> ExBanking.create_user("user to get balance")
        :ok
        iex> ExBanking.get_balance("user to get balance", "BRL")
        {:ok, 0.0}

  """
  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number} | banking_error
  defdelegate get_balance(user, currency), to: Transaction

  @doc """
  Decreases from_user’s balance in given currency by amount value
  Increases to_user’s balance in given currency by amount value
  Returns balance of from_user and to_user in given format
  ### Examples

        iex> ExBanking.create_user("user to send")
        :ok
        iex> ExBanking.create_user("user to receive")
        :ok
        iex> ExBanking.deposit("user to send", 1.22, "BRL")
        {:ok, 1.22}
        iex> ExBanking.send("user to send", "user to receive", 1.22, "BRL")
        {:ok, 0.0, 1.22}

  """
  @spec send(
          from_user :: String.t(),
          to_user :: String.t(),
          amount :: number,
          currency :: String.t()
        ) :: {:ok, from_user_balance :: number, to_user_balance :: number} | banking_error
  defdelegate send(from_user, to_user, amount, currency), to: Transaction
end
