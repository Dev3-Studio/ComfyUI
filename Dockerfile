FROM python:3.12

# Install required packages
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# Set the working directory
WORKDIR /comfyui

# Install any needed packages specified in requirements.txt
RUN pip install torch torchvision torchaudio
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /comfyui
COPY . .

## Install custom nodes
WORKDIR /comfyui/custom_nodes/ComfyUI-Impact-Pack
RUN python install-manual.py

# Expose the port
EXPOSE 8188

# Run the application
WORKDIR /
COPY /dockerentry.sh /entry.sh
ENTRYPOINT ["/bin/bash", "/entry.sh"]