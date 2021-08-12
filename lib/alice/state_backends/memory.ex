defmodule Alice.StateBackends.Memory do
  @moduledoc "State backend for Alice using an in-memory map for persistence"

  @behaviour Alice.StateBackends.StateBackend

  defprotocol MemoryValue do
    @fallback_to_any true
    def convert(value)
  end

defimpl MemoryValue, for: Date do
    def convert(value), do: to_string(value)
  end

  defimpl MemoryValue, for: Any do
    def convert(value), do: value
  end
