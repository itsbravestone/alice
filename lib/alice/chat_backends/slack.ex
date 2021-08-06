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
