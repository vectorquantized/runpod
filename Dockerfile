FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

WORKDIR /workspace

# Install Miniconda
RUN mkdir -p ~/miniconda3 && \
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  -O ~/miniconda3/miniconda.sh && \
  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
  rm ~/miniconda3/miniconda.sh && \
  ~/miniconda3/bin/conda init bash && \
  echo ". ~/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc && \
  echo "conda activate base" >> ~/.bashrc

# Update PATH to include Conda
ENV PATH="/root/miniconda3/bin:$PATH"

# Create a conda environment
RUN conda create -n cuda python=3.10

# Set SHELL for conda environment
SHELL ["conda", "run", "-n", "cuda", "/bin/bash", "-c"]
RUN python --version && which pip && conda info --envs
RUN pip install -q coloredlogs watermark && \
  echo "Installing transformers and datasets" && \
  pip install -q transformers datasets && \
  echo "Installing scikit-learn and libtmux" && \
  pip install -q scikit-learn libtmux && \
  pip install vllm

RUN apt-get update -y && \
  apt-get install -y mpi libaio-dev libfmt-dev zsh curl

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

RUN echo "Done with all installations"
