defmodule Watcher do

  def start(config) do
    listen(config, start_timer)
  end

  def listen(config, timer) do
    receive do
      { :watch, pid } -> watch_directory(pid, config[:directory], timer)
    end
    listen(config, timer)
  end

  defp start_timer do
    :erlang.now |> :calendar.now_to_datetime
  end

  defp watch_directory(pid, directory, timer) do

    watch_directory(pid, directory, timer)
  end
end

defmodule WatcherTest do
  use ExUnit.Case

  test :start_monitoring_directory do
    watch = spawn_link(Watcher, :start, [[directory: "/fixtures"]])
    watch <- { :directory, self } 
    assert_receive { :directory, "/fixtures" }
  end

end
