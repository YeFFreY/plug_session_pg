defmodule Mix.Tasks.PlugSessionPg.Install do
  use Mix.Task

  import Mix.Generator
  import Mix.Ecto

  @shortdoc "Generate migration script for plug session table"
  def run([module_name]) do
    gen_session_migration_change
    |> gen_migration(module_name)
  end

  defp gen_migration(change, module_name) do
    repo = get_application_repo(module_name)
    path = Path.relative_to(migrations_path(repo), Mix.Project.app_path())
    file = Path.join(path, "#{timestamp}_create_plug_sessions.exs")
    mod = Module.concat([repo, Migrations, CreatePlugSessions])
    create_file(file, migration_template(mod: mod, change: change))
    file
  end

  defp get_application_repo(module_name) do
    repo = Module.concat(module_name, "Repo")
    ensure_repo(repo, [])
    repo
  end

  defp gen_session_migration_change do
    migration = """
      create table(:plug_sessions) do
        add(:sid, :string, null: false)
        add(:data, :map, null: false)
        add(:last_modified, :naive_datetime, null: false, default: fragment("now()"))
        add(:created, :naive_datetime, null: false, default: fragment("now()"))
      end
      create(unique_index(:plug_sessions, [:sid]))
    """
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  embed_template(:migration, """
  defmodule <%= inspect @mod %> do
    use Ecto.Migration

    def change do
  <%= @change %>
    end
  end
  """)
end
