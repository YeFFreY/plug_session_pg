ExUnit.start()

# Ecto.Adapters.SQL.Sandbox.mode(TestRepo, :manual)
{:ok, _pid} = TestRepo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(TestRepo, {:shared, self()})
