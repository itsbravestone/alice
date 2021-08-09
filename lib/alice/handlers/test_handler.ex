defmodule Alice.Handlers.TestHandler do
  @moduledoc "Purely for testing purposes"
  use Alice.Router

  route ~r/cmd1/, :command1
  route ~r/hidden/, :hidden
  command ~r/cmd1/, :command1
  command ~r/cmd2/i, :command2
  command ~r/cmd3/i, :command3
  command ~r/no docs/i, :no_docs

  @doc "`cmd1`: does some stuff"
  def command1(_conn), do: nil
