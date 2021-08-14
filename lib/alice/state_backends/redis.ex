defmodule Alice.StateBackends.Redis do
  @moduledoc "State backend for Alice using Redis for persistence"

  @behaviour Alice.StateBackends.StateBackend

  alias Alice.StateBackends.RedixPool
