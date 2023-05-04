#!/bin/bash

# Set the path to the RaspiOS Bullseye arm64 image
IMAGE="2023-05-03-raspios-bullseye-arm64.img"
IMAGE_XZ="${IMAGE}.xz"
URL="https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/${IMAGE_XZ}"

# Set the path to the QEMU ARM64 BIOS
BIOS="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"

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

# Check if the BIOS file exists
if [ ! -f "${BIOS}" ]; then
  echo "BIOS file '${BIOS}' not found. Please ensure QEMU is installed correctly and the path to the BIOS file is correct."
  exit 1
fi

# Start QEMU
qemu-system-aarch64 \
  -M virt \
  -m 2048 \
  -smp 4 \
  -cpu cortex-a72 \
  -bios "${BIOS}" \
  -serial stdio \
  -device virtio-gpu-pci \
  -device usb-ehci \
  -device usb-kbd \
  -device usb-mouse \
  -drive file="${IMAGE}",if=virtio,format=raw \
  -netdev user,id=vmnic \
  -device virtio-net-device,netdev=vmnic \
  -display default
