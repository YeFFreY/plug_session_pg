ExUnit.configure(exclude: [skip: true])
ExUnit.start()

{:ok, _pid} = TestPlugSessionPg.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(TestPlugSessionPg.Repo, {:shared, self()})

defmodule TestHelper do
  import ExUnit.Assertions

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  def assert_file(file, match) do
    cond do
      is_list(match) ->
        assert_file(file, &Enum.each(match, fn m -> assert &1 =~ m end))

      is_binary(match) or Regex.regex?(match) ->
        assert_file(file, &assert(&1 =~ match))

      is_function(match, 1) ->
        assert_file(file)
        match.(File.read!(file))
    end
  end
end
