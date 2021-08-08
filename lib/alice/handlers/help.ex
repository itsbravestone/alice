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

@doc """
  `help all` - outputs the help text for each route in every handler
  `help <handler name>` - outputs the help text for a single matching handler
  """
  def keyword_help(conn) do
    keyword_help(conn, get_term(conn))
  end

  defp keyword_help(conn, "all") do
    [
      @pro_tip,
      "_Here are all the routes and commands I know about…_"
      | Enum.map(Router.handlers(), &help_for_handler/1)
    ]
    |> Enum.reduce(conn, &reply/2)
  end

defp keyword_help(conn, term) do
    Router.handlers()
    |> Enum.find(&(downcased_handler_name(&1) == term))
    |> deliver_help(conn)
  end

  defp handler_list do
    Router.handlers()
    |> Enum.map(&handler_name/1)
    |> Enum.sort()
    |> Enum.map(&"> *#{&1}*")
    |> Enum.join("\n")
  end

  defp get_term(conn) do
    conn
    |> Conn.last_capture()
    |> String.downcase()
    |> String.replace(~r/[_\s]+/, "")
    |> String.trim()
  end

defp handler_name(handler) do
    handler
    |> to_string()
    |> String.split(".")
    |> Enum.reverse()
    |> hd
  end

  defp downcased_handler_name(handler) do
    handler
    |> handler_name()
    |> String.downcase()
  end

  defp deliver_help(nil, conn) do
    ~s(I can't find a handler matching "#{get_term(conn)}")
    |> reply(conn)
    |> general_help()
  end

defp deliver_help(handler, conn) do
    [
      @pro_tip,
      ~s(_Here are all the routes and commands I know for "#{get_term(conn)}"_),
      help_for_handler(handler)
    ]
    |> Enum.join("\n\n")
    |> reply(conn)
  end

  def help_for_handler(handler) do
    [
      ">*#{path_name(handler)}*",
      format_routes("Routes", handler.routes, handler),
      format_routes("Commands", handler.commands, handler),
      ""
    ]
    |> compact()
    |> Enum.join("\n")
  end

  defp path_name("Elixir." <> name), do: name
  defp path_name(handler), do: handler |> to_string() |> path_name()

  defp format_routes(_title, [], _handler), do: nil
