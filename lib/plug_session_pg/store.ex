defmodule PlugSessionPg.Store do
  import Ecto.Query
  require Logger
  @behaviour Plug.Session.Store

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

  @impl true
  def put(_conn, nil, data, repo) do
    sid = Base.encode64(:crypto.strong_rand_bytes(96))
    repo.insert_all "plug_sessions", [[sid: sid, data: data]]
    sid
  end

  def put(_conn, sid, data, repo) do
    Logger.info "put sid store"
    IO.inspect sid
    IO.inspect data
    sid
  end

  @impl true
  def delete(_conn, sid, repo) do
    Logger.info "delete from store"
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
