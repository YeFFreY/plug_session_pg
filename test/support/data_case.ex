defmodule PlugSessionPg.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias TestRepo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import PlugSessionPg.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TestRepo, {:shared, self()})
    end

    :ok
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
