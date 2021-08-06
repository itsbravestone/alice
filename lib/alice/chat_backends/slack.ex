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
