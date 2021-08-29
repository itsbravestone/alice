defmodule Alice.HandlerCase do
  @moduledoc """
  Helpers for writing tests of Alice Handlers.
  When used it accepts the following options:
  * `:handlers` - The handler (or List of handlers) that you want to test. Defaults to [] (thereby giving you no handlers to test)
  `use`ing this handler automatically brings in `ExUnit.Case` as well.
  ## Examples
      defmodule Alice.Handlers.ExampleHandlerTest do
        use Alice.HandlerCase, handlers: Alice.Handlers.ExampleHandler
        test "it replies" do
          send_message("hello")
          assert first_reply() == "world"
        end
      end
  """
@type conn() :: %Alice.Conn{}

  @doc """
  Generates a fake connection for testing purposes.
  Can be called as `fake_conn/0` to generate a quick connection.
  ## Examples
      test "you can directly use the reply function" do
        conn = fake_conn()
        reply(conn, "hello world")
        assert first_reply() == "hello world"
      end
  """
  
   @spec fake_conn() :: conn()
  def fake_conn(), do: fake_conn("")

  @doc """
  Generates a fake connection for testing purposes.
  Can be called as `fake_conn/1` to pass a message.
  ## Examples
      test "you can set the message in the conn" do
        conn = fake_conn("message")
        send_message(conn)
        assert first_reply() == "hello world"
      end
  """
@spec fake_conn(String.t()) :: conn()
  def fake_conn(text) do
    %Alice.Conn{
      message: %{text: text, channel: :channel, user: "fake_user_id"},
      slack: fake_slack("fake_user"),
      state: %{}
    }
  end

  @spec fake_conn_with_thread(String.t(), String.t()) :: conn()
  def fake_conn_with_thread(thread \\ "fake thread", text \\ "") do
    conn = %{message: message} = fake_conn(text)
    message = Map.put(message, :thread_ts, thread)
    Map.put(conn, :message, message)
  end
@doc """
  Generates a fake connection for testing purposes.
  Can be called as `fake_conn/2` to set options. Options can either be `:state`
  or `:capture`, but not both. Using `:capture` is helpful if you want to unit
  test your handler functions.
  ## Examples
      test "you can set state" do
        conn = fake_conn("message", state: %{some: "state"})
        conn = send_message(conn)
        assert first_reply() == "hello world"
        assert conn.state.some == "state"
      end
      test "you can set the regix and call the handler directly" do
        conn = fake_conn("message", ~r"^(.+)")
        MyHandler.do_something(conn)
        assert first_reply() == "hello world, you said 'message'"
      end
  """

@spec fake_conn(String.t(), opts :: [state: map()] | [capture: Regex.t()]) :: conn()
  def fake_conn(text, state: state) do
    %{fake_conn(text) | state: state}
  end

  def fake_conn(text, capture: capture_regex) do
    text
    |> fake_conn()
    |> Alice.Conn.add_captures(capture_regex)
  end

defp fake_slack(name) do
    %{
      me: %{id: "alice"},
      users: [
        %{"id" => "alice", "name" => "alice"},
        %{"id" => name, "name" => name}
      ]
    }
  end

  @doc """
    Sends a message through Alice that can be captured by the handlers.
    Can either be called with a message `String` or `Alice.Conn`
    ## Examples
        test "it sends a message" do
          send_message("test message")
          assert first_reply() == "reply from handler"
        end
        test "it sends a message with a conn" do
          conn = fake_conn("test message")
          send_message(conn)
          assert first_reply() == "reply from handler"
        end
  """
