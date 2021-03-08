help:
		@cat Makefile

GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=11.0
CUDNN_VERSION?=8
SRC?=$(pwd)

build:
		docker build -t mykeras36 --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run --rm -it  -p 20:22 -p 7000:7000 -v $(SRC):/storage  --env KERAS_BACKEND=$(BACKEND) mykeras36 bash

