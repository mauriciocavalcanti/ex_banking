defmodule Helper do
  @moduledoc """
  Set of helper functions
  """
  def to_decimal(number) do
    number
    |> Decimal.cast()
    |> Decimal.round(2)
    |> Decimal.to_float()
  end
end
