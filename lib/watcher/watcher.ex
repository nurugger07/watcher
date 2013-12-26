defmodule Watch do
  def start(root) do
    start_watching(root, self)
    listen
  end

  def listen do
    receive do
      { :notify, changes } -> changes
    end
    listen
  end

  def start_watching(root, pid) do
    File.ls!(root) |> Enum.filter(&add_watchers("#{root}/#{&1}"))
  end

  def add_watchers(dir, pid) do
    cond do
      File.dir?(dir) -> [start_watching(dir, pid)]
    end
  end

  defp start_timer, do: :erlang.now |> :calendar.now_to_local_time

  defp watch_directory(pid, directory, timer) do
    { :ok, stats } = File.stat(directory)
    { :ok, timer } = check_for_changes(stats.mtime, timer, pid)
    :timer.sleep(100)
    watch_directory(pid, directory, timer)
  end

  defp check_for_changes(mtime, timer, pid) when mtime > timer do
    { :ok, start_timer }
  end
  defp check_for_changes(mtime, timer, _) do
    { :ok, timer } 
  end
end
