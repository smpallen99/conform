defmodule Conform.Config do
  @moduledoc """
  This module is responsible for reading and writing,
  and manipulating *.config files
  """

  @doc """
  Read an app.config/sys.config from the provided path.
  Returns the config as Elixir terms.
  """
  @spec read(binary) :: [term]
  def read(path), do: path |> String.to_char_list |> :file.consult

  @doc """
  Write a config (in the form of Elixir terms) to disk in
  the required *.config format.
  """
  @spec write(binary, term) :: :ok | {:error, term}
  def write(path, config) do
    '#{path}' |> :file.write_file(:io_lib.fwrite('~p.\n', [config]))
  end

  @doc """
  Print a config to the console with pretty formatting
  """
  def print(config) do
    config
    |> pretty
    |> print_raw
  end

  @doc """
  Print a config to the console without applying any formatting
  """
  def print_raw(config) do
    IO.puts(config)
  end

  @doc """
  apply pretty formatting to a config
  """
  def pretty(config) do
    config
    |> Inspect.Algebra.to_doc(%Inspect.Opts{pretty: true, limit: 1000})
    |> Inspect.Algebra.format(80)
  end

  @doc """
  Merge two configs together to produce a new unified config.
  The second argument represents the config with the highest precedence
  in the case of conflicts.
  """
  @spec merge(Keyword.t, Keyword.t) :: Keyword.t
  def merge(config1, config2) do
    Keyword.merge(config1, config2, fn _, app1, app2 ->
      Keyword.merge(app1, app2)
    end)
  end

end
