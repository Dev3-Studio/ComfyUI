#!/bin/bash

# Log function for consistent messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Environment variable check
if [ -z "$CIVITAI_TOKEN" ]; then
    log "Error: CIVITAI_TOKEN environment variable is not set."
    exit 1
fi

# Ensure model directory exists
MODEL_DIR="/comfyui/models/checkpoints"
if [ ! -d "$MODEL_DIR" ]; then
    log "Model directory does not exist. Creating it ..."
    mkdir -p "$MODEL_DIR"
fi

# Function to download models if they don't exist
download_model() {
    local model_path="$MODEL_DIR/$1"
    local url="$2"
    if [ -f "$model_path" ]; then
        log "Model $1 already exists. Skipping download."
    else
        log "Downloading $1 ..."
        wget -O "$model_path" "$url" || { log "Failed to download $1"; exit 1; }
    fi
}

# Download SDXL models
log "Checking for existing SDXL models ..."
download_model "dreamshaperxl.safetensors" "https://civitai.com/api/download/models/351306?type=Model&format=SafeTensor&size=full&fp=fp16&token=$CIVITAI_TOKEN"
download_model "juggernautxl.safetensors" "https://civitai.com/api/download/models/782002?type=Model&format=SafeTensor&size=full&fp=fp16&token=$CIVITAI_TOKEN"
download_model "ponyxl.safetensors" "https://civitai.com/api/download/models/1085338?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=$CIVITAI_TOKEN"

# Cleanup process for output folder
log "Deleting files in /comfyui/output/* folder every 12 hours ..."
pgrep -f "rm -rf /comfyui/output/*" >/dev/null 2>&1 || (
    while true; do
        log "Deleting files in /comfyui/output/* folder ..."
        rm -rf /comfyui/output/*
        sleep 43200
    done &
)

# Graceful shutdown
trap "log 'Shutting down...'; kill 0; exit 0" SIGINT SIGTERM

# Run application
if [ "$CPU_ONLY" = true ]; then
    log "Running in CPU only mode ..."
    python3 /comfyui/main.py --cpu --listen --port 8188
else
    log "Running in GPU mode ..."
    python3 /comfyui/main.py --listen --port 8188
fi