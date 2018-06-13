defmodule PlugSessionPgTest do
  use PlugSessionPg.DataCase
  import Ecto.Query, only: [from: 2]

  alias PlugSessionPg.Store, as: Subject
  alias TestRepo

  @existing_sid "bob"

  setup do
    TestRepo.insert_all "plug_sessions", [[sid: @existing_sid, data: %{message: "the message"}]]
    :ok
  end

  describe "init/1" do
    test "returns the given repo" do
      assert Subject.init(repo: TestRepo) === TestRepo
    end
  end

  describe "put/4" do
    test "Error raised when repo not given as option" do
      assert_raise KeyError, fn ->
        Subject.init(none: "none")
      end
    end
  end

  describe "put/4 without sid" do
    test "Data in brand new session is saved in database with sid" do
      data = %{message: "message in database"}
      sid = Subject.put(%{}, nil, data, TestRepo)
      refute is_nil(sid)
      assert Map.equal? data, session_data(sid)
    end

    test "nil is replace by empty map for new session" do
      sid = Subject.put(%{}, nil, nil, TestRepo)
      refute is_nil(sid)
      assert Map.equal? %{}, session_data(sid)
    end
  end
   
  describe "put/4 with existing sid" do
    test "unknown sid is ignored" do
      data = %{message: "message in database"}
      sid = "unknown_sid"
      Subject.put(%{}, sid, data, TestRepo)
      assert is_nil(session_data(sid))
    end

    test "update session data" do
      data = %{message: "message in database", other: 4}
      sid = Subject.put(%{}, @existing_sid, data, TestRepo)
      assert sid == @existing_sid
      assert Map.equal? data, session_data(@existing_sid)
    end
  end

  describe "get/3" do
    test "retrieves the session from the store when it exists" do
      data = %{message: "save me then retrived me", foo: "bar"}
      sid = Subject.put(%{}, nil, data, TestRepo)
      assert Subject.get(nil, sid, TestRepo) == {sid, data}
    end

    test "returns a nil session if it does not exists in the store" do
      unknown_sid = Base.encode64(:crypto.strong_rand_bytes(96))
      assert Subject.get(nil, unknown_sid, TestRepo) == {nil, %{}}
    end
  end

  defp session_data(sid) do
    query = from s in "plug_sessions",
              where: s.sid == ^sid,
              select: s.data
    result = TestRepo.one(query)
    case result do
      nil -> nil
      data -> data |> Map.new(fn {k, v} -> { String.to_existing_atom(k), v} end)
    end
  end
end
