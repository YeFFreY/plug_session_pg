defmodule PlugSessionPgTest do
  use PlugSessionPg.DataCase
  import Ecto.Query, only: [from: 2]

  alias PlugSessionPg.Store, as: Subject
  alias TestRepo

  describe "init/1" do
    test "returns the given repo" do
      assert Subject.init(repo: TestRepo) === TestRepo
    end

    test "Error raised when repo not given as option" do
      assert_raise KeyError, fn ->
        Subject.init(none: "none")
      end
    end

    test "Data in brand new session is saved in database with sid" do
      data = %{message: "message in database"}
      sid = Subject.put(%{}, nil, data, TestRepo)
      refute is_nil(sid)
      assert Map.equal? data, session_data(sid)
    end
  end

  defp session_data(sid) do
    query = from s in "plug_sessions",
              where: s.sid == ^sid,
              select: s.data
    TestRepo.one(query)
     |> Map.new(fn {k, v} -> { String.to_existing_atom(k), v} end)
  end
end
