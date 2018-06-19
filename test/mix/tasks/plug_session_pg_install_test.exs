defmodule Mix.Tasks.PlugSessionPg.InstallTest do
  use ExUnit.Case, async: true

  describe "run/1" do
    test "generates the migration script" do
      Mix.Tasks.PlugSessionPg.Install.run([])
    end
  end
end