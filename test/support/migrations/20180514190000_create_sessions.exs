defmodule TestMigration do
  use Ecto.Migration

  def change do
    create table(:plug_sessions) do
      add :sid, :string, null: false
      add :data, :string, null: false
    end

    create unique_index(:plug_sessions, [:sid])
  end
end
