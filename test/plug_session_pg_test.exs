defmodule PlugSessionPgTest do
  use ExUnit.Case
  alias PlugSessionPg.Store, as: Subject

  @table "table_name"
  @default_table "plug_session"

  describe "init/1" do
    test "returns the table configuration if given" do
      assert Subject.init(table: @table) == @table
    end
    test "returns the default table configuration if none given" do
      assert Subject.init(none: "none") == @default_table
    end
  end
end
