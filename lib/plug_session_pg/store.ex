defmodule PlugSessionPg.Store do
  @behaviour Plug.Session.Store

  import Ecto.Query, only: [from: 2]

  alias PlugSessionPg.RepoNotDefined

  @impl true
  def init(opts) do
    with :error <- Keyword.fetch(opts, :repo),
         :error <- Application.fetch_env(:plug_session_pg, :repo) do
      raise RepoNotDefined
    else
      {:ok, repo} -> repo
    end
  end

  @impl true
  def get(_conn, sid, repo) do
    fetched_data =
      sid
      |> plug_session_query
      |> repo.one

    case fetched_data do
      nil -> {nil, %{}}
      data -> {sid, to_map(data)}
    end
  end

  def put(conn, nil, nil, repo), do: put(conn, nil, %{}, repo)

  @impl true
  def put(_conn, nil, data, repo) do
    sid = Base.encode64(:crypto.strong_rand_bytes(96))
    repo.insert_all("plug_sessions", [[sid: sid, data: data]])
    sid
  end

  def put(_conn, sid, data, repo) do
    session = from(s in "plug_sessions", where: s.sid == ^sid)
    repo.update_all(session, set: [data: data, last_modified: NaiveDateTime.utc_now()])
    sid
  end

  @impl true
  def delete(_conn, sid, repo) do
    session = from(s in "plug_sessions", where: s.sid == ^sid)
    repo.delete_all(session)
    :ok
  end

  defp plug_session_query(sid) do
    from(
      s in "plug_sessions",
      where: s.sid == ^sid,
      select: s.data
    )
  end

  defp to_map(data) do
    Map.new(data, fn {k, v} -> {String.to_existing_atom(k), v} end)
  end
end
