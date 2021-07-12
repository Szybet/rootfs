#!/bin/sh

ROOTED=$(cat /opt/root/rooted)
FLAG=$(cat /boot/flags/USBNET_ENABLE)
DEVICE=$(cat /opt/inkbox_device)

if [ "${ROOTED}" == "true" ]; then
	if [ "${FLAG}" == "true" ]; then
		rc-service mass_storage stop &>/dev/null
		if [ "${DEVICE}" == "n705" ] || [ "${DEVICE}" == "n905b" ] || [ "${DEVICE}" == "n905c" ] || [ "${DEVICE}" == "n613" ]; then
			insmod "/modules/arcotg_udc.ko"
			insmod "/modules/g_ether.ko"
		elif [ "${DEVICE}" == "n873" ]; then
			insmod "/modules/fs/configfs/configfs.ko"
			insmod "/modules/drivers/usb/gadget/libcomposite.ko"
			insmod "/modules/drivers/usb/gadget/function/u_ether.ko"
			insmod "/modules/drivers/usb/gadget/function/usb_f_ecm.ko"
			insmod "/modules/drivers/usb/gadget/function/usb_f_eem.ko"
			insmod "/modules/drivers/usb/gadget/function/usb_f_ecm_subset.ko"
			insmod "/modules/drivers/usb/gadget/function/usb_f_rndis.ko"
			insmod "/modules/drivers/usb/gadget/legacy/g_ether.ko"
		else
			insmod "/modules/arcotg_udc.ko"
			insmod "/modules/g_ether.ko"
		fi
		ifconfig usb0 up
		ifconfig usb0 192.168.2.2
	else
		echo "USB networking is disabled. Please set the USBNET_ENABLE flag and try again."
	fi
else
	# Device is not rooted; enforcing security policy.
	echo "Permission denied; USB networking is disabled."
fi
