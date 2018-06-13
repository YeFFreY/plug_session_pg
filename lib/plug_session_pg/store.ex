defmodule PlugSessionPg.Store do
  import Ecto.Query
  require Logger
  @behaviour Plug.Session.Store
  import Ecto.Query, only: [from: 2]

  @impl true
  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  @impl true
  def get(_conn, sid, repo) do
    Logger.info "get store"
    IO.inspect sid
    data = sid
      |> plug_session_query 
      |> repo.one 
      |> to_map
    {sid, data}
  end

  def put(conn, nil, nil, repo), do: put(conn, nil, %{}, repo)

  @impl true
  def put(_conn, nil, data, repo) do
    sid = Base.encode64(:crypto.strong_rand_bytes(96))
    repo.insert_all "plug_sessions", [[sid: sid, data: data]]
    sid
  end

  def put(_conn, sid, data, repo) do
    session = from s in "plug_sessions", where: s.sid == ^sid
    repo.update_all session, set: [data: data, last_modified: NaiveDateTime.utc_now]
    sid
  end

  @impl true
  def delete(_conn, sid, repo) do
    :ok
  end

  defp plug_session_query(sid) do
    from s in "plug_sessions",
    where: s.sid == ^sid,
    select: s.data
  end
  defp to_map(data) do
    Map.new(data, fn {k, v} -> { String.to_existing_atom(k), v} end)
  end
end
