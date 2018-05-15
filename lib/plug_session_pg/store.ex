defmodule PlugSessionPg.Store do
  @behaviour Plug.Session.Store
  @default_table_name "plug_session"

  def init(opts) do
    IO.inspect opts
    Keyword.fetch!(opts, :repo)
  end

  def get(_conn, sid, table) do
    {sid, nil}
  end

  def put(_conn, nil, data, table) do
    sid = Base.encode64(:crypto.strong_rand_bytes(96))
    sid
  end

  def put(_conn, sid, data, table) do
    sid
  end

  def delete(_conn, sid, table) do
    :ok
  end
end
