defmodule PlugSessionPg.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias TestPlugSessionPg.Repo, as: TestRepo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import PlugSessionPg.DataCase

      defp lookup_session_data(sid) do
        query =
          from(
            s in "plug_sessions",
            where: s.sid == ^sid,
            select: s.data
          )

        result = TestRepo.one(query)

        case result do
          nil -> nil
          data -> data |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
        end
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestPlugSessionPg.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TestPlugSessionPg.Repo, {:shared, self()})
    end

    :ok
  end
end
