#!/bin/bash
export LC_ALL=C

function ensure_default_route() {

	device="$1"

	# Verify default ipv4 route using this device exists
	if   ! ip -4 route show default | grep -q "$device" ; then

		echo "ipv4 '${device}' default route missing! Reconnecting '${device}'!!"
		nmcli device connect "$device"

	fi

	# Verify default ipv6 route using this device exists
	if ! ip -6 route show default | grep -q "$device" ; then

		echo "ipv6 '${device}' default route missing! Reconnecting '${device}'!!"
		nmcli device connect "$device"

	fi
}

function enable_disable_wifi() {
	
	result=$(nmcli device status | grep -w "ethernet" | grep -w "connected")
	wifi_status="$(nmcli radio wifi)"
	
	# Disable wifi if needed
	if [ -n "$result" ] && [ "$wifi_status" == "enabled" ]; then
		
		echo "Ethernet Connected! Disabling Wifi!!"
		nmcli radio wifi off
		
		sleep 3s
		device="$(echo "$result" | head -n1 | awk '{print $1}')"
		if [ -n "$device" ]; then
			ensure_default_route "$device"
		fi

	# Enable wifi if needed
	elif [ -z "$result" ] && [ "$wifi_status" == "disabled" ]; then

		echo "Ethernet not connected! Ensuring wifi is enabled!!"
		nmcli radio wifi on
	
		sleep 3s	
		device="$(nmcli device status | grep -w "wifi" | grep -w "connected" | head -n1 | awk '{print $1}')"
		if [ -n "$device" ]; then
			ensure_default_route "$device"
		fi

	fi
}

if [ "$2" = "up" ]; then
	enable_disable_wifi
fi

if [ "$2" = "down" ]; then
	enable_disable_wifi
fi

