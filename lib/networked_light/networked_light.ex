defmodule NetworkedLight do
  use Application

  @ledpin Application.get_env(:ledpin, :pin)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, gpio_pid} = Gpio.start_link(@ledpin, :output)

    # For more infomation on the child spec go to:
    # http://erlang.org/doc/design_principles/sup_princ.html
    children = [
      worker(Task, [fn -> init_kernel_modules() end], restart: :transient, id: Nerves.Init.KernelModules),
      worker(NetworkedLight.Server, [gpio_pid], restart: :transient, id: Nerves.Init.NetworkedLight),
    ]

    opts = [strategy: :one_for_one, name: NetworkedLight.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Before Wifi will work, the Broadcom
  brcmfmac driver module needs to be loaded.

  The modprobe command adds brcmfmac to the
  Linux kernel
  """
  def init_kernel_modules, do: System.cmd("modprobe", ["brcmfmac"])
end

