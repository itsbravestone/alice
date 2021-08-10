defmodule Alice.Handlers.Utils do
  @moduledoc "Some utility routes for Alice"
  use Alice.Router

  route ~r/\Aping\z/i, :ping
  command ~r/\bping\z/i, :ping
  command ~r/\binfo\z/i, :info
  command ~r/\bdebug state\z/i, :debug_state
  command ~r/\bdebug slack\z/i, :debug_slack
  command ~r/\bdebug conn\z/i, :debug_conn
