defmodule PublisherTest do
  use ExUnit.Case
  doctest Publisher

  test "greets the world" do
    assert Publisher.hello() == :world
  end
end
