local network = {}

function network.setup(ssid, pwd)
  wifi.setphymode(wifi.PHYMODE_G)
  wifi.setmode(wifi.SOFTAP)

  config = {
    ssid = ssid,
    pwd = pwd,
    auth = wifi.WPA2_PSK,
    max = 1,
    ip = "192.168.1.1",
    netmask = "255.255.255.0",
    gateway = "192.168.1.1"
  }
  wifi.ap.config(config)
  wifi.ap.setip(config)

  dhcp_config = {
    start = "192.168.1.100"
  }
  wifi.ap.dhcp.config(dhcp_config)
  wifi.ap.dhcp.start()

  print(wifi.getchannel())
  print(wifi.ap.getip())
end

return network
