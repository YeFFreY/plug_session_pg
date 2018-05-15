defmodule PlugSessionPgTest do
  use PlugSessionPg.DataCase
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
  end
end
