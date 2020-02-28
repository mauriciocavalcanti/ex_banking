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

  """
  @spec create_user(user :: String.t()) :: :ok | banking_error
  defdelegate create_user(user), to: User

  @doc """
  Increases user’s balance in given currency by amount value
  Returns new_balance of the user in given format

  """
  @spec deposit(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | banking_error
  defdelegate deposit(user, amount, currency), to: Transaction

  @doc """
  Decreases user’s balance in given currency by amount value
  Returns new_balance of the user in given format

  """
  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | banking_error
  defdelegate withdraw(user, amount, currency), to: Transaction

  @doc """
  Returns balance of the user in given format

  """
  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number} | banking_error
  defdelegate get_balance(user, currency), to: Transaction

  @doc """
  Decreases from_user’s balance in given currency by amount value
  Increases to_user’s balance in given currency by amount value
  Returns balance of from_user and to_user in given format
  """
  @spec send(
          from_user :: String.t(),
          to_user :: String.t(),
          amount :: number,
          currency :: String.t()
        ) :: {:ok, from_user_balance :: number, to_user_balance :: number} | banking_error
  defdelegate send(from_user, to_user, amount, currency), to: Transaction
end
