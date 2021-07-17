defmodule SensorHubTest do
  use ExUnit.Case
  doctest SensorHub

  test "greets the world" do
    assert SensorHub.hello() == :world
  end
end
