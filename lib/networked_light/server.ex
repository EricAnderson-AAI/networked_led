defmodule NetworkedLight.Server do
  use GenServer

  #####
  # External API

  def start_link(gpio_pid) do
    GenServer.start_link(__MODULE__, gpio_pid, name: __MODULE__)
  end

  def led_on do
    GenServer.call(__MODULE__, :led_on)
  end

  def led_off do
    GenServer.call(__MODULE__, :led_off)
  end

  #####
  # GenServer Implementation

  def handle_call(:led_on, _from, gpio_pid) do
    {:reply, Gpio.write(gpio_pid, 0), gpio_pid}
  end

  def handle_call(:led_off, _from, gpio_pid) do
    {:reply, Gpio.write(gpio_pid, 1), gpio_pid}
  end
end

