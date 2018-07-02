defmodule PlugSessionPg.Cleaner do
  @moduledoc """
  Cleans inactive sessions,
  """

  use GenServer

  import Ecto.Query, only: [from: 2]
  import Ecto.Query.API, only: [datetime_add: 3]

  def start_link(_args \\ nil) do
    with {:ok, repo} <- Application.fetch_env(:plug_session_pg, :repo),
         {:ok, max_age} <- Application.fetch_env(:plug_session_pg, :max_age) do
      timeout = round(max_age / 2 * 1000)
      IO.inspect timeout
      GenServer.start_link(__MODULE__, {repo, max_age, timeout})
    else
      :error -> {:error, :bad_configuration}
    end
  end

  def init({_, _, timeout} = args) do
    schedule_work(timeout)
    {:ok, args}
  end

  def handle_info(:work, {repo, max_age, timeout} = state) do
    schedule_work(timeout)
    clean_sessions(repo, max_age)
    {:noreply, state}
  end

  def handle_info(_, _) do
    {:ok, %{}}
  end

  def clean_sessions(repo, max_age) do
    older = NaiveDateTime.add(NaiveDateTime.utc_now(), -max_age, :second)

    sessions_to_delete =
      from(
        s in "plug_sessions",
        where: s.last_accessed < ^older
      )

    repo.delete_all(sessions_to_delete)
  end

  defp schedule_work(timeout) do
    Process.send_after(self(), :work, timeout)
  end
end
