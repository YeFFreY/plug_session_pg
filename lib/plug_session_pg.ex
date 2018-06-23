defmodule PlugSessionPg do
  @moduledoc """
  Storing plug sessions in database using Ecto.
  """
  use Application

  def start(_type, _args) do
    children = [PlugSessionPg.Cleaner]
    opts = [strategy: :one_for_one, name: PlugSessionPg.Cleaner]
    Supervisor.start_link(children, opts)
  end
end
