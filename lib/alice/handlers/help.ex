defmodule Alice.Handlers.Help do
  @moduledoc "A handler to return helptext for all registered handlers"
  use Alice.Router
  alias Alice.Router
  alias Alice.Conn

  command ~r/>:? help\z/i, :general_help
  command ~r/\bhelp (.*)\z/i, :keyword_help

  @pro_tip "_*Pro Tip:* Commands require you @ mention me, routes do not_"

  @doc "`help` - lists all known handlers"
  def general_help(conn) do
    """
    _Here are all the handlers I know about…_
    #{handler_list()}
    _Get info about a specific handler with_ `@alice help <handler name>`
    _Get info about all handlers with_ `@alice help all`
    _Feedback on Alice is appreciated. Please submit an issue at https://github.com/alice-bot/alice/issues _
    """
    |> reply(conn)
  end
