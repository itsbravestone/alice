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
