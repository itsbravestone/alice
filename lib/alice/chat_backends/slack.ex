defmodule Alice.ChatBackends.Slack do
  @moduledoc "Adapter for Slack"
  use Slack

  alias Alice.Conn
  alias Alice.Router
  alias Alice.Earmuffs
  alias Alice.StateBackends.Redis

  def start_link do
    Slack.Bot.start_link(
      __MODULE__,
      init_state(),
      get_token(),
      %{name: __MODULE__}
    )
  end

defp init_state do
    case Application.get_env(:alice, :state_backend) do
      :redis -> Redis.get_state()
      _else -> %{}
    end
  end

  defp get_token do
    Application.get_env(:alice, :api_key)
  end

def send_message(message, channel) do
    send(__MODULE__, {:message, message, channel})
    {:ok}
  end

  def handle_connect(slack, state) do
    IO.puts("Connected to Slack as @#{slack.me.name}")
    {:ok, state}
  end
