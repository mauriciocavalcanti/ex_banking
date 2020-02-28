defmodule Banking.Application do
  use Application

  def start(_type, _args) do
    Server.UserSupervisor.start_link()
  end
end
