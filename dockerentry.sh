#!/bin/bash

# Download SDXL models
echo "Downloading SDXL models ..."
wget -O /comfyui/models/checkpoints/dreamshaperxl.safetensors "https://civitai.com/api/download/models/351306?type=Model&format=SafeTensor&size=full&fp=fp16&token=$CIVITAI_TOKEN"
#wget -O /comfyui/models/checkpoints/juggernautxl.safetensors "https://civitai.com/api/download/models/782002?type=Model&format=SafeTensor&size=full&fp=fp16&token=$CIVITAI_TOKEN"
#wget -O /comfyui/models/checkpoints/ponyxl.safetensors "https://civitai.com/api/download/models/1085338?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=$CIVITAI_TOKEN"

echo "Deleting files in /comfyui/output/* folder every 12 hours ..."
while true; do
    echo "Deleting files in /comfyui/output/* folder ..."
    rm -rf /comfyui/output/*
    sleep 43200
done &

if [ "$CPU_ONLY" = true ]; then
    echo "Running in CPU only mode ..."
    python3 /comfyui/main.py --cpu --listen --port 8188
else
    echo "Running in GPU mode ..."
    python3 /comfyui/main.py --listen --port 8188
fi


