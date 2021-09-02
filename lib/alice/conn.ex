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
