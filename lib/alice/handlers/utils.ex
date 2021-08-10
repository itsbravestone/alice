defmodule Alice.Handlers.Utils do
  @moduledoc "Some utility routes for Alice"
  use Alice.Router

  route ~r/\Aping\z/i, :ping
  command ~r/\bping\z/i, :ping
  command ~r/\binfo\z/i, :info
  command ~r/\bdebug state\z/i, :debug_state
  command ~r/\bdebug slack\z/i, :debug_slack
  command ~r/\bdebug conn\z/i, :debug_conn
  
  @doc "`ping` - responds with signs of life"
  def ping(conn) do
    ["PONG!", "Can I help you?", "Yes...I'm still here.", "I'm alive!"]
    |> random_reply(conn)
  end

  @doc "`info` - info about Alice and the system"
  def info(conn) do
    mem = :erlang.memory()
    total = "Total memory: #{bytes_to_megabytes(mem[:total])}MB"
    process = "Allocated to processes: #{bytes_to_megabytes(mem[:processes])}MB"

    conn
    |> reply("Alice #{alice_version()} - https://github.com/alice-bot")
    |> reply("#{total} - #{process}")
  end
  
