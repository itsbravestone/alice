defmodule Alice.StateBackends.Redis do
  @moduledoc "State backend for Alice using Redis for persistence"

  @behaviour Alice.StateBackends.StateBackend

  alias Alice.StateBackends.RedixPool

 @migration_key "Alice.State.Migrated.v0.3.5"

  defp migrate_redis do
    ["GET", @migration_key]
    |> RedixPool.command!()
    |> case do
      nil -> migrate_redis!()
      _ -> :ok
    end
  end

defp migrate_redis! do
    state = do_get_state()
    Enum.each(state, fn {key, val} -> put(state, key, val) end)
    RedixPool.command!(["SET", @migration_key, true])
    :ok
  end

  def get(_state, key, default \\ nil) do
    ["GET", encode_key(key)]
    |> RedixPool.command!()
    |> handle_get_result(default)
  end
