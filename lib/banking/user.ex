defmodule Banking.User do
  @moduledoc """
  Client for user
  """
  alias Server.UserSupervisor

  def create_user(user) when is_binary(user) do
    case UserSupervisor.start_child(user) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> {:error, :user_already_exists}
    end
  end

  def create_user(_), do: {:error, :wrong_arguments}
end
