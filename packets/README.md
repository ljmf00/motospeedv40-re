# Packet Sniffing

## Requirements

- Wireshark GUI
- Wireshark CLI
- Oracle VM VirtualBox
- Windows ISO
- Motospeed Drivers
- usbutils
- diffutils
- ... Knowledge :)

## Setup the environment

1. You need to activate `usbmon` kernel module to collect traces of I/O on the
USB bus, using modprobe.

	```shell
	# modprobe usbmon
	```

2. 

2. Check out your device address using the tool `lsusb` from usbutils.

	The output should be something similar to this:
	
	```
	 $ lsusb
	Bus 002 Device 003: ID 0bda:8153 Realtek Semiconductor Corp. RTL8153 Gigabit Ethernet Adapter
	Bus 002 Device 002: ID 05e3:0612 Genesys Logic, Inc. Hub
	Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
	Bus 001 Device 022: ID 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless Network Adapter
	Bus 001 Device 007: ID 8087:0a2a Intel Corp. 
	Bus 001 Device 021: ID 2717:003b Xiaomi Inc. MI Wireless Mouse
	Bus 001 Device 009: ID 27c6:5740 Shenzhen Goodix Technology Co.,Ltd. Fingerprint Reader
	Bus 001 Device 008: ID 0bda:0129 Realtek Semiconductor Corp. RTS5129 Card Reader Controller
	Bus 001 Device 006: ID 05e3:0608 Genesys Logic, Inc. Hub
	Bus 001 Device 019: ID 258a:1006  
	Bus 001 Device 020: ID 04d9:a09f Holtek Semiconductor, Inc. E-Signal LUOM G10 Mechanical Gaming Mouse
	Bus 001 Device 015: ID 05e3:0610 Genesys Logic, Inc. 4-port hub
	Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
	```

	For this mouse, the device ID is `04d9:a09f`, so you can deduce the Bus ID
	and the Device ID from the output, which in this case, is connected on
	Bus `001` and the Device is `020`.

3. You are now ready to go with Wireshark, but before that you should capture only
the packets you are interested on.

	Using the wireshark filters, you can do something like this:
	
	```
	usb.device_address == 20 && usb.data_flag == "present (0)"
	```

	You could also filter the Bus ID if you have the same ID in a different Bus.

4. After saving the selected and captured packets to a `.pcapng` file, you should
now be able to diff to see the differences using `tshark`.

	```shell
	$ tshark -r foo_packets.pcapng > foo_packets
	```

	Now if you have two packet files (e.g.: `foo_packets` and `bar_packets`) you
	can diff them with `diff` from diffutils.

	```shell
	$ diff -u foo_packets bar_packets > foo_bar_packets.diff
	```

	Example of the final output:
	```diff
	--- apply_report150	2019-12-19 15:50:54.202978322 +0000
	+++ apply_report250	2019-12-19 15:51:01.929644805 +0000
	@@ -1,4 +1,4 @@
	-        host → 1.15.0       USB 72 URB_CONTROL out  2694f508b81da676 
	+        host → 1.15.0       USB 72 URB_CONTROL out  26945508581da676 
	         host → 1.15.0       USB 72 URB_CONTROL out  269015087cfda676 
	       1.15.0 → host         USB 72 URB_CONTROL in   268f850884fdb6c6
	         host → 1.15.0       USB 72 URB_CONTROL out  269045087c4da676 
	```

	**Tip:** To get rid of some useless columns, deactivate them on Wireshark GUI.