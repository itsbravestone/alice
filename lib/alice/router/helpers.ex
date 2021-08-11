defmodule Alice.Router.Helpers do
  @moduledoc """
  Helpers to make replying easier in handlers
  """

  alias Alice.Conn
  require Logger
  
@doc """
  Reply to a message in a handler.
  Takes a conn and a response string in any order.
  Sends `response` back to the channel that triggered the handler.
  Adds random tag to end of image urls to break Slack's img cache.
  """
  @spec reply(String.t(), %Conn{}) :: %Conn{}
  @spec reply(%Conn{}, String.t()) :: %Conn{}
  @spec reply([String.t(), ...], %Conn{}) :: %Conn{}
  @spec reply(%Conn{}, [String.t(), ...]) :: %Conn{}
  def reply(resp, conn = %Conn{}), do: reply(conn, resp)
  def reply(conn = %Conn{}, resp) when is_list(resp), do: random_reply(conn, resp)
