defmodule Mix.Tasks.PlugSessionPg.InstallTest do
  use ExUnit.Case, async: true

  @module_name "TestPlugSessionPg"

  describe "run/1" do
    test "returns :error when the given module doesn't contain a valid ecto Repo" do
      assert :error == Mix.Tasks.PlugSessionPg.Install.run(["TestUnknownModule"])
    end

    test "generates the migration script when the given module contain a valid ecto Repo" do
      {:ok, migration} = Mix.Tasks.PlugSessionPg.Install.run([@module_name])

      TestHelper.assert_file(migration, fn file ->
        assert file =~ "defmodule #{@module_name}.Repo.Migrations.CreatePlugSessions do"
        assert file =~ "create table(:plug_sessions) do"
        assert file =~ "add(:sid, :string, null: false)"
        assert file =~ "add(:data, :map, null: false)"

        assert file =~
                 "add(:last_modified, :naive_datetime, null: false, default: fragment(\"now()\"))"

        assert file =~ "add(:created, :naive_datetime, null: false, default: fragment(\"now()\"))"
        assert file =~ "end"
        assert file =~ "create(unique_index(:plug_sessions, [:sid]))"
      end)

      File.rm(migration)
    end
  end
end
