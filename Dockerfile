FROM pytorch/pytorch:2.7.0-cuda12.8-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HF_HOME=/workspace/.cache/huggingface

RUN apt-get update && apt-get install -y --no-install-recommends \
      git git-lfs ffmpeg libgl1 libglib2.0-0 libgomp1 libxrender1 libxext6 libsm6 \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir --upgrade pip uv

WORKDIR /workspace

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --system -r /tmp/requirements.txt && uv pip install --system scipy

# flash-attn requires CUDA-enabled PyTorch to be present in the build image.
RUN uv pip install --system --no-build-isolation flash-attn

COPY . /workspace

EXPOSE 7860
CMD ["python", "demo.py"]
