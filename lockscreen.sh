#!/bin/bash

# Define the image paths
IMAGE1="/home/ion606/Pictures/windowsanime2.jpg"
IMAGE2="/home/ion606/Pictures/windowsanime.jpg"

# Randomly select one of the images
if [ $((RANDOM % 2)) -eq 0 ]; then
  SELECTED_IMAGE="$IMAGE1"
else
  SELECTED_IMAGE="$IMAGE2"
fi

# Run swaylock with the selected image
swaylock --image "$SELECTED_IMAGE"
