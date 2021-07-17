defmodule Phoenix.Endpoint.Watcher do
  @moduledoc false
  require Logger

  def child_spec(args) do
    %{
      id: make_ref(),
      start: {__MODULE__, :start_link, [args]},
      restart: :transient
    }
  end

  def start_link({cmd, args, opts}) do
    Task.start_link(__MODULE__, :watch, [to_string(cmd), args, opts])
  end

  def watch(cmd, args, opts) do
    merged_opts = Keyword.merge(
      [into: IO.stream(:stdio, :line), stderr_to_stdout: true], opts)
    :ok = validate(cmd, args, merged_opts)

    try do
      System.cmd(cmd, args, merged_opts)
    catch
      :error, :enoent ->
        relative = Path.relative_to_cwd(cmd)
        Logger.error "Could not start watcher #{inspect relative} from #{inspect cd(merged_opts)}, executable does not exist"
        exit(:shutdown)
    else
      {_, 0} ->
        :ok
      {_, _} ->
        # System.cmd returned a non-zero exit code
        # sleep for a couple seconds before exiting to ensure this doesn't
        # hit the supervisor's max_restarts / max_seconds limit
        Process.sleep(2000)
        exit(:watcher_command_error)
    end
  end

  # We specially handle Node.js to make sure we
  # provide a good getting started experience.
  defp validate("node", [script|_], merged_opts) do
    script_path = Path.expand(script, cd(merged_opts))

    cond do
      !System.find_executable("node") ->
        Logger.error "Could not start watcher because \"node\" is not available. Your Phoenix " <>
                     "application is still running, however assets won't be compiled. " <>
                     "You may fix this by installing \"node\" and then running \"npm install\" inside the \"assets\" directory."
        exit(:shutdown)

      not File.exists?(script_path) ->
        Logger.error "Could not start Node.js watcher because script #{inspect script_path} does not " <>
                     "exist. Your Phoenix application is still running, however assets " <>
                     "won't be compiled. You may fix this by running \"npm install\" inside the \"assets\" directory."
        exit(:shutdown)

      true -> :ok
    end
  end

  defp validate(_cmd, _args, _opts) do
    :ok
  end

  defp cd(opts), do: opts[:cd] || File.cwd!()
end
