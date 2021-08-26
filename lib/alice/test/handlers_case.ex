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
