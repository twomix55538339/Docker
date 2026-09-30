FROM nvidia/cuda:12.8.0-devel-ubuntu22.04

# 基本ツール
RUN apt-get update && apt-get install -y \
    wget git build-essential gcc g++ ninja-build \
    python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/miniconda && \
    rm /tmp/miniconda.sh

ENV PATH=/opt/miniconda/bin:$PATH

# conda 環境
RUN conda create -n mmdet3d-vod python=3.10 -y
SHELL ["conda", "run", "-n", "mmdet3d-vod", "/bin/bash", "-c"]

# PyTorch cu128
RUN pip install -U pip setuptools wheel
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# CUDA Toolkit（nvcc はベースイメージに既にある）
RUN apt-get update && apt-get install -y cuda-toolkit-12-8

# RTX 5090（sm_120）向け設定
ENV CUDA_HOME=/usr/local/cuda
ENV CUDACXX=/usr/local/cuda/bin/nvcc
ENV TORCH_CUDA_ARCH_LIST="12.0"
ENV MMCV_CUDA_ARCH="12.0"

# Python 基本ツール
RUN pip install -U pip wheel ninja psutil openmim opencv-python-headless
RUN pip install "setuptools<82"

# mmcv v2.1.0
RUN git clone https://github.com/open-mmlab/mmcv.git /workspace/mmcv && \
    cd /workspace/mmcv && \
    git checkout v2.1.0 && \
    rm -rf build dist mmcv.egg-info && \
    CC=/usr/bin/gcc CXX=/usr/bin/g++ CUDAHOSTCXX=/usr/bin/g++ NVCC_CCBIN=/usr/bin/g++ \
    MAX_JOBS=1 pip install -v --no-build-isolation -e .

# mmengine + mmdet
RUN mim install "mmengine>=0.8.0,<1.0.0"
RUN pip install "mmdet>=3.0.0rc5,<3.4.0"

# mmdetection3d
RUN git clone https://github.com/open-mmlab/mmdetection3d.git /workspace/mmdetection3d && \
    cd /workspace/mmdetection3d && \
    rm -rf build dist *.egg-info && \
    pip install -v --no-build-isolation -e .
