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

def reply(conn = %Conn{message: %{channel: channel, thread_ts: thread}, slack: slack}, resp) do
    resp
    |> Alice.Images.uncache()
    |> outbound_api().send_message(channel, slack, thread)

    conn
  end

def reply(conn = %Conn{message: %{channel: channel}, slack: slack}, resp) do
    resp
    |> Alice.Images.uncache()
    |> outbound_api().send_message(channel, slack)

    conn
  end
  
  defp outbound_api do
    Application.get_env(:alice, :outbound_client, Alice.ChatBackends.SlackOutbound)
  end

  @doc """
  Takes a conn and a list of possible response in any order.
  Replies with a random element of the `list` provided.
  """
  @spec random_reply(list(), %Conn{}) :: %Conn{}
  @spec random_reply(%Conn{}, list()) :: %Conn{}
  def random_reply(list, conn = %Conn{}), do: random_reply(conn, list)
  def random_reply(conn = %Conn{}, list), do: list |> Enum.random() |> reply(conn)

 @doc """
  Reply with random chance.
  Examples
      > chance_reply(conn, 0.5, "sent half the time")
      > chance_reply(conn, 0.25, "sent 25% of the time", "sent 75% of the time")
  """
  @spec chance_reply(%Conn{}, float(), String.t(), String.t() | :noreply) :: %Conn{}
  def chance_reply(conn = %Conn{}, chance, positive, negative \\ :noreply) do
    success? = :rand.uniform() <= chance
    chance_reply(conn, {success?, positive, negative})
  end
