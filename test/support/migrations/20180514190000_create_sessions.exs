defmodule TestMigration do
  use Ecto.Migration

  def change do
    create table(:plug_sessions) do
      add(:sid, :string, null: false)
      add(:data, :map, null: false)
      add(:last_accessed, :naive_datetime, null: false, default: fragment("(now() at time zone 'utc')"))
      add(:created, :naive_datetime, null: false, default: fragment("(now() at time zone 'utc')"))
    end

    create(unique_index(:plug_sessions, [:sid]))
  end
end
