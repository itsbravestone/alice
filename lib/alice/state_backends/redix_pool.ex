defmodule Alice.StateBackends.RedixPool do
  @moduledoc "Redis connection pool for the `StateBackends.Redis`"

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    pool_opts = [
      name: {:local, :redix_poolboy},
      worker_module: Redix,
      size: 10,
      max_overflow: 5
    ]
