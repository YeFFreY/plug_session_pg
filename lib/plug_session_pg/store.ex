defmodule PlugSessionPg.Store do
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
    {sid, %{name: "bouboule"}}
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
end
