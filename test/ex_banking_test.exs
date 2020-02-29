defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  describe "create_user" do
    test "success creating user" do
      assert :ok == ExBanking.create_user("create user")
    end

    test "wrong arguments" do
      assert {:error, :wrong_arguments} == ExBanking.create_user(000)
    end

    test "user already exists" do
      ExBanking.create_user("user exists")
      assert {:error, :user_already_exists} == ExBanking.create_user("user exists")
    end
  end

  describe "deposit" do
    ExBanking.create_user("deposit")

    test "success depositing to user" do
      assert {:ok, 100.0} == ExBanking.deposit("deposit", 100, "BRL")
      assert {:ok, 1100.0} == ExBanking.deposit("deposit", 1000, "BRL")
      assert {:ok, 1199.99} == ExBanking.deposit("deposit", 99.99, "BRL")
      assert {:ok, 10_001_199.99} == ExBanking.deposit("deposit", 10_000_000.00000111, "BRL")
    end

    test "wrong_arguments" do
      assert {:error, :wrong_arguments} == ExBanking.deposit("any user", -100, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.deposit("any user", 100, 123)
      assert {:error, :wrong_arguments} == ExBanking.deposit(123, 100, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.deposit("any user", "100", "BRL")
    end

    test "user does not exist" do
      assert {:error, :user_does_not_exist} == ExBanking.deposit("I don't exist", 100, "BRL")
    end
  end

  describe "withdraw" do
    ExBanking.create_user("withdraw")
    ExBanking.create_user("no more money")
    ExBanking.deposit("withdraw", 100_000, "BRL")

    test "success withdrawing from user" do
      assert {:ok, 99950.0} == ExBanking.withdraw("withdraw", 50, "BRL")
      assert {:ok, 99849.88} == ExBanking.withdraw("withdraw", 100.12, "BRL")
      assert {:ok, 849.88} == ExBanking.withdraw("withdraw", 99000, "BRL")
      assert {:ok, 0.0} == ExBanking.withdraw("withdraw", 849.88, "BRL")
    end

    test "wrong arguments" do
      assert {:error, :wrong_arguments} == ExBanking.withdraw("any user", -100, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.withdraw("any user", 100, 123)
      assert {:error, :wrong_arguments} == ExBanking.withdraw(123, 100, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.withdraw("any user", "100", "BRL")
    end

    test "user does not exist" do
      assert {:error, :user_does_not_exist} == ExBanking.withdraw("I don't exist", 100, "BRL")
    end

    test "not enough money" do
      assert {:error, :not_enough_money} == ExBanking.withdraw("no more money", 1000, "BRL")
    end
  end

  describe "get_balance" do
    ExBanking.create_user("get balance")

    test "success getting balance from user" do
      assert {:ok, 0.0} == ExBanking.get_balance("get balance", "BRL")
    end

    test "wrong arguments" do
      assert {:error, :wrong_arguments} == ExBanking.get_balance("get balance", 1123)
      assert {:error, :wrong_arguments} == ExBanking.get_balance(123, "BRL")
    end

    test "user does not exist" do
      assert {:error, :user_does_not_exist} == ExBanking.get_balance("I don't exist", "BRL")
    end
  end

  describe "send" do
    ExBanking.create_user("from_user")
    ExBanking.create_user("to_user")
    ExBanking.deposit("from_user", 100, "BRL")

    test "success sending amount from user to user" do
      assert {:ok, 50.0, 50.0} == ExBanking.send("from_user", "to_user", 50, "BRL")
    end

    test "sender does not exist" do
      assert {:error, :sender_does_not_exist} ==
               ExBanking.send("I don't exist", "to_user", 50, "BRL")
    end

    test "receiver does not exist" do
      assert {:error, :receiver_does_not_exist} ==
               ExBanking.send("from_user", "I don't exist", 50, "BRL")
    end

    test "wrong arguments" do
      assert {:error, :wrong_arguments} == ExBanking.send("from_user", "to_user", 50, 123)
      assert {:error, :wrong_arguments} == ExBanking.send("from_user", "from_user", 50, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.send(123, "to_user", 50, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.send("from_user", 123, 50, "BRL")
      assert {:error, :wrong_arguments} == ExBanking.send("from_user", "to_user", "50", "BRL")
    end

    test "not enough money" do
      assert {:error, :not_enough_money} == ExBanking.send("from_user", "to_user", 5000, "BRL")
    end
  end

  describe "process limiter" do
    ExBanking.create_user("processes")

    for _n <- 1..100 do
      Task.async(fn -> ExBanking.deposit("processes", 10, "currency") end)
    end

    test "balance should be less than 1000" do
      {:ok, balance} = ExBanking.get_balance("processes", "currency")
      assert balance < 1000
    end
  end
end
