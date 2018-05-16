defmodule PlugSessionPg.Store do
  require Logger
  @behaviour Plug.Session.Store

  @impl true
  def init(opts) do
    Logger.info "init store"
    IO.inspect opts
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
    Logger.info "put nil store"
    IO.inspect data
    sid = Base.encode64(:crypto.strong_rand_bytes(96))
    IO.inspect sid
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
