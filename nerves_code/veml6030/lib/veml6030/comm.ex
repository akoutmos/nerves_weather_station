defmodule VEML6030.Comm do
  alias Circuits.I2C
  alias VEML6030.Config

  @light_register <<4>>

  def discover(possible_addresses \\ [0x10, 0x48]) do
    I2C.discover_one!(possible_addresses)
  end

  def open(bus_name) do
    {:ok, i2c} = I2C.open(bus_name)

    i2c
  end

  def write_config(configuration, i2c, sensor) do
    command = Config.to_integer(configuration)

    I2C.write(i2c, sensor, <<0, command::little-16>>)
  end

  def read(i2c, sensor, configuration) do
    <<value::little-16>> = I2C.write_read!(i2c, sensor, @light_register, 2)

    Config.to_lumens(configuration, value)
  end
end
