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
