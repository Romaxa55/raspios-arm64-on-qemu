#!/bin/bash

# Set the path to the RaspiOS Bullseye arm64 image
IMAGE="2023-05-03-raspios-bullseye-arm64.img"
IMAGE_QCOW2="2023-05-03-raspios-bullseye-arm64.qcow2"
IMAGE_XZ="${IMAGE}.xz"
URL="https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/${IMAGE_XZ}"

# Set the path to the QEMU ARM64 BIOS
BIOS="/opt/homebrew/Cellar/qemu/8.0.0/share/qemu/edk2-aarch64-code.fd"

# Check if the image file exists
if [ ! -f "${IMAGE}" ]; then
  if [ ! -f "${IMAGE_XZ}" ]; then
    echo "Image file '${IMAGE}' not found. Downloading the image..."
    curl -O "${URL}"
  fi

  echo "Unpacking the image file..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    tar -xf "${IMAGE_XZ}"
  else
    # Linux
    unxz "${IMAGE_XZ}"
  fi
fi

# Convert the image to qcow2 format
if [ ! -f "${IMAGE_QCOW2}" ]; then
  echo "Converting the image to qcow2 format..."
  qemu-img convert -f raw -O qcow2 "${IMAGE}" "${IMAGE_QCOW2}"
fi

# Check and resize the image if necessary
REQUIRED_SIZE=8589934592 # 8 GiB in bytes
CURRENT_SIZE=$(qemu-img info --output=json "${IMAGE_QCOW2}" | jq '.["virtual-size"]')

if [ "${CURRENT_SIZE}" -lt "${REQUIRED_SIZE}" ]; then
  echo "Resizing the image to 8 GiB..."
  qemu-img resize "${IMAGE_QCOW2}" 8G
fi

# Check if the BIOS file exists
if [ ! -f "${BIOS}" ]; then
  echo "BIOS file '${BIOS}' not found. Please ensure QEMU is installed correctly and the path to the BIOS file is correct."
  exit 1
fi

# Start QEMU
qemu-system-aarch64 \
   -machine raspi3b \
   -cpu cortex-a72 \
   -dtb bcm2710-rpi-3-b-plus.dtb \
   -m 1G -smp 4 -serial stdio \
   -kernel kernel8.img \
   -sd ./2023-05-03-raspios-bullseye-arm64.qcow2 \
   -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
   -device usb-mouse -device usb-kbd
