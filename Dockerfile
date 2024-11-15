FROM python:3.12

# Install required packages
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# Set the working directory
WORKDIR /comfyui

# Copy the current directory contents into the container at /comfyui
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install torch torchvision torchaudio
RUN pip install -r requirements.txt

# Install custom nodes
WORKDIR /comfyui/custom_nodes/ComfyUI-Impact-Pack
RUN pip install -r requirements.txt
RUN python install-manual.py

# Expose the port
EXPOSE 8188

# Run the application
WORKDIR /comfyui
CMD ["python", "main.py", "--listen", "--port", "8188"]