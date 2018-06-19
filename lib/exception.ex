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
