defmodule Alice.Conn do
  @moduledoc """
  Alice.Conn defines a struct that is used throughout alice to hold state
  during the lifetime of a message handling.
  An Alice.Conn struct contains 3 things: `message`, the incoming message
  that is currently being handled; `slack`, a data structure from the Slack
  library that holds all the information about the Slack instance; and `state`,
  which is the state of the bot that is persisted between messages. State
  defaults to an in-memory Map, but may be configured to be backed by Redis.
  The Alice.Conn module also contains several helper functions that operate on
  Conn structs.
  """

  alias Alice.Conn

  defstruct([:message, :slack, :state])

  @doc """
  Convenience function to make a new `Alice.Conn` struct
  """
  def make({message, slack, state}) do
    %Conn{message: message, slack: slack, state: state}
  end

  def make(message, slack, state \\ %{}) do
    make({message, slack, state})
  end

 @doc """
  Returns a boolean depending on whether or
  not the incoming message is a command
  """
  def command?(conn = %Conn{}) do
    String.contains?(conn.message.text, "<@#{conn.slack.me.id}>")
  end

  @doc """
  Returns the name of the user for the incoming message
  """
  def user(conn = %Conn{}) do
    user_data(conn)["name"]
  end

@doc """
  Returns the timezone offset for the user
  """
  def tz_offset(conn = %Conn{}) do
    user_data(conn)["tz_offset"]
  end

  @doc """
  Returns the timestamp of the message
  """
  def timestamp(conn = %Conn{}) do
    conn.message.ts
  end
