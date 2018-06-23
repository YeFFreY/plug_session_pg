defmodule PlugSessionPgTest.CleanerTest do
  use PlugSessionPg.DataCase
  import Ecto.Query, only: [from: 2]

  alias PlugSessionPg.Cleaner, as: Subject
  alias TestPlugSessionPg.Repo, as: TestRepo

  @existing_sid "existing_session"
  @data %{message: "the message in the session"}
  @old_offset -1
  setup do
    older = NaiveDateTime.add(NaiveDateTime.utc_now(), @old_offset, :second)

    TestRepo.insert_all("plug_sessions", [[sid: @existing_sid, data: @data, last_accessed: older]])

    :ok
  end

  describe "start_link/1" do
    test "starts the GenServer if required configuration is found" do
      Application.put_env(:plug_session_pg, :repo, TestRepo)
      Application.put_env(:plug_session_pg, :max_age, 1)

      assert {:ok, _} = Subject.start_link()
    end

    test "fails to start the GenServer if repo is not defined" do
      Application.delete_env(:plug_session_pg, :repo)
      Application.put_env(:plug_session_pg, :max_age, 1)

      assert {:error, :bad_configuration} = Subject.start_link()
    end

    test "fails to start the GenServer if max_age is not defined" do
      Application.put_env(:plug_session_pg, :repo, TestRepo)
      Application.delete_env(:plug_session_pg, :max_age)

      assert {:error, :bad_configuration} = Subject.start_link()
    end
  end

  describe "clean_sessions/2" do
    test "delete old session" do
      refute is_nil(lookup_session_data(@existing_sid))
      Subject.clean_sessions(TestRepo, 1)
      assert is_nil(lookup_session_data(@existing_sid))
    end

    test "keep recent session" do
      refute is_nil(lookup_session_data(@existing_sid))
      Subject.clean_sessions(TestRepo, 3)
      refute is_nil(lookup_session_data(@existing_sid))
    end
  end

  describe "Cleaner GenServer" do
    test "triggers session cleaning after timeout" do
      Application.put_env(:plug_session_pg, :repo, TestRepo)
      Application.put_env(:plug_session_pg, :max_age, 1)

      refute is_nil(lookup_session_data(@existing_sid))
      assert {:ok, _} = Subject.start_link()

      Process.sleep(500)
      refute is_nil(lookup_session_data(@existing_sid))

      Process.sleep(600)
      assert is_nil(lookup_session_data(@existing_sid))
    end
  end
end
