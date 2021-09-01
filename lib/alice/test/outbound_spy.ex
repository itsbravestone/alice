defmodule Alice.ChatBackends.OutboundSpy do
  @moduledoc """
  A Spy to capture messages sent to the OutboundClient during testing.
  """
  @behaviour Alice.ChatBackends.OutboundClient

  @doc "Sends the message back to the process so it can be retrieved later during the test"
  @spec send_message(message :: String.t(), channel :: String.t(), slack :: map()) :: :ok
  def send_message(message, channel, slack) do
    send(self(), {:send_message, %{response: message, channel: channel, slack: slack}})
    :ok
  end
