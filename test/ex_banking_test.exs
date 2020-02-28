defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  describe "create_user" do
    test "success creating user" do
      assert :ok == ExBanking.create_user("user")
    end

    test "wrong arguments" do
      assert {:error, :user_already_exists} == ExBanking.create_user(000)
    end

    test "user already exists" do
      ExBanking.create_user("user")
      assert {:error, :user_already_exists} == ExBanking.create_user("user")
    end
  end

  describe "deposit" do
    test "success depositing to user" do
      ExBanking.create_user("user")
      assert {:ok, 100.0} == ExBanking.deposit("user", 100, "BRL")
    end
  end

  describe "withdraw" do
    test "success withdrawing from user" do
      ExBanking.create_user("user")
      ExBanking.deposit("user", 100, "BRL")
      assert {:ok, 50.0} == ExBanking.withdraw("user", 50, "BRL")
    end
  end

  describe "get_balance" do
    test "success getting balance from user" do
      ExBanking.create_user("user")
      assert {:ok, 0.0} == ExBanking.get_balance("user", "BRL")
    end
  end

  describe "send" do
    test "success sending amount from user to user" do
      ExBanking.create_user("from_user")
      ExBanking.create_user("to_user")
      ExBanking.deposit("from_user", 100, "BRL")
      assert {:ok, 50.0, 50.0} == ExBanking.send("from_user", "to_user", 50, "BRL")
    end
  end
end
