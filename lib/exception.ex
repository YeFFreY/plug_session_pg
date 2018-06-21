defmodule PlugSessionPg.RepoNotDefined do
  @moduledoc """
  Error raised when `PlugSessionPg.Store` tries to access the Ecto Repo not configured
  """

  defexception []

  def message(_) do
    """
    Please provide an Ecto Repo in the application configuration:
      config :plug_session_pg,
        repo: YourModule.Repo
    """
  end
end
defmodule PlugSessionPg.RepoNotFound do
  @moduledoc """
  Error raised when `Mix.Tasks.PlugSessionPg.Install' does not find the repo based on the given module
  """

  defexception []

  def message(module_name) do
    """
    The provided module doesn't seem to contain an ecto Repo (#{module_name}.Repo)
    """
  end
end