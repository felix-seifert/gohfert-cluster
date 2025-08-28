# Required Router Settings to Enable MAAS to Discover and Manage Servers

Several network settings have to be adjusted that MAAS works. In my case, these settings have to be applied to the
central UniFi Ubiquiti Cloud Gateway:

* Enable DHCP while MAAS is initially setup. Somehow the fixed IP address is not reliable if no DHCP server is active.
    * If not already done, assign a fixed IP address to the MAAS server.
    * After the initial MAAS setup, relay the DHCP functionality of the router to the MAAS server, so that MAAS is the
      only DHCP server of the network.
