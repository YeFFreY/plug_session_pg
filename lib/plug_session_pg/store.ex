defmodule PlugSessionPg.Store do
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
    {sid, %{name: "bouboule"}}
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
end
