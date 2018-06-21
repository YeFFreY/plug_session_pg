defmodule Mix.Tasks.PlugSessionPg.InstallTest do
  use ExUnit.Case, async: true

  describe "run/1" do
    test "returns :error when the given module doesn't contain a valid ecto Repo" do
      assert :error == Mix.Tasks.PlugSessionPg.Install.run(["UnknownModule"])
    end
  end
end