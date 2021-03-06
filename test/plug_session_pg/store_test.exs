defmodule PlugSessionPgTest.StoreTest do
  use PlugSessionPg.DataCase
  import Ecto.Query, only: [from: 2]

  alias PlugSessionPg.Store, as: Subject
  alias TestPlugSessionPg.Repo, as: TestRepo
  alias PlugSessionPg.RepoNotDefined

  @existing_sid "existing_session"
  @data %{message: "the message in the session"}

  setup do
    TestRepo.insert_all("plug_sessions", [[sid: @existing_sid, data: @data]])
    :ok
  end

  describe "init/1" do
    test "returns the given repo when repo provided through config" do
      Application.put_env(:plug_session_pg, :repo, TestRepo)
      assert Subject.init(none: "none") === TestRepo
    end

    test "returns the given repo only provided through init method" do
      Application.delete_env(:plug_session_pg, :repo)
      assert Subject.init(repo: TestRepo) === TestRepo
    end

    test "Error raised when repo not given as option neither from the application config or the init method" do
      Application.delete_env(:plug_session_pg, :repo)

      assert_raise RepoNotDefined, fn ->
        Subject.init(none: "none")
      end
    end
  end

  describe "put/4" do
    test "puts the session in the store and returns sid" do
      sid = Subject.put(%{}, nil, @data, TestRepo)
      refute is_nil(sid)
      assert Map.equal?(@data, lookup_session_data(sid))
    end

    test "puts the session with empty map" do
      sid = Subject.put(%{}, nil, nil, TestRepo)
      refute is_nil(sid)
      assert Map.equal?(%{}, lookup_session_data(sid))
    end

    test "puts nothing in the store when the given sid is unknown" do
      data = %{message: "message in database"}
      sid = "unknown_sid"
      Subject.put(%{}, sid, data, TestRepo)
      assert is_nil(lookup_session_data(sid))
    end

    test "updates the session in the store when the sid is known" do
      data = %{message: "message in database", other: 4}
      sid = Subject.put(%{}, @existing_sid, data, TestRepo)
      assert sid == @existing_sid
      assert Map.equal?(data, lookup_session_data(@existing_sid))
    end
  end

  describe "get/3" do
    test "retrieves the session from the store when it exists" do
      assert Subject.get(nil, @existing_sid, TestRepo) == {@existing_sid, @data}
    end

    test "updates the last_accessed timestamp" do
      before_last_accessed = lookup_session_last_accessed(@existing_sid)
      Subject.get(nil, @existing_sid, TestRepo)
      after_last_accessed = lookup_session_last_accessed(@existing_sid)

      assert NaiveDateTime.compare(after_last_accessed, before_last_accessed) == :gt
    end
    test "returns a nil session if it does not exists in the store" do
      unknown_sid = "unknown_sid"
      assert Subject.get(nil, unknown_sid, TestRepo) == {nil, %{}}
    end
  end

  describe "delete/3" do
    test "deletes the session from the store if it exists" do
      assert :ok = Subject.delete(nil, @existing_sid, TestRepo)
      assert is_nil(lookup_session_data(@existing_sid))
    end

    test "deletes ONLY the session from the store for the given sid" do
      other_sid = Subject.put(%{}, nil, @data, TestRepo)
      assert :ok = Subject.delete(nil, @existing_sid, TestRepo)
      assert is_nil(lookup_session_data(@existing_sid))
      assert Map.equal?(@data, lookup_session_data(other_sid))
    end

    test "deletes nothing from the store when given sid doesn't exist" do
      assert :ok = Subject.delete(nil, "unknown_sid", TestRepo)
    end
  end
end
