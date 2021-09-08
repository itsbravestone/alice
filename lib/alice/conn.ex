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

 @doc """
  Builds a string to use as an @reply back to the user who sent the message
  """
  def at_reply_user(conn = %Conn{}) do
    "<@#{user_data(conn)["id"]}>"
  end

  defp user_data(%Conn{message: %{user: id}, slack: %{users: users}}) do
    Enum.find(users, &(&1["id"] == id))
  end
@doc """
  Used internally to add the regex captures to the `message`
  """
  def add_captures(conn = %Conn{}, pattern) do
    conn.message
    |> Map.put(:captures, Regex.run(pattern, conn.message.text))
    |> make(conn.slack, conn.state)
  end

  @doc """
  Get the last capture from the `conn`
  """
  def last_capture(%Conn{message: %{captures: captures}}) do
    captures |> Enum.reverse() |> hd
  end

@doc """
  Used internally to sanitize the incoming message text
  """
  def sanitize_message(conn = %Conn{message: message = %{text: text}}) do
    message
    |> Map.put(:original_text, text)
    |> Map.put(:text, sanitize_text(text))
    |> make(conn.slack, conn.state)
  end

defp sanitize_text(text) do
    text
    |> remove_smart_quotes
    |> remove_formatted_emails
    |> remove_formatted_urls
  end

  defp remove_smart_quotes(text) do
    text
    |> String.replace(~s(“), ~s("))
    |> String.replace(~s(”), ~s("))
    |> String.replace(~s(’), ~s('))
  end
