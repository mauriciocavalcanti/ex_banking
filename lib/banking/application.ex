defmodule Banking.Application do
  @moduledoc """
  Application start that initializes Supervisor
  """
  use Application

  def start(_type, _args) do
    Server.UserSupervisor.start_link()
  end
end
