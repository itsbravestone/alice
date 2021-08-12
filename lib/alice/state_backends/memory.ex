defmodule Alice.StateBackends.Memory do
  @moduledoc "State backend for Alice using an in-memory map for persistence"

  @behaviour Alice.StateBackends.StateBackend

  defprotocol MemoryValue do
    @fallback_to_any true
    def convert(value)
  end
