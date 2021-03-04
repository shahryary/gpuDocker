ARG cuda_version=10.0
ARG cudnn_version=7
FROM nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      libhdf5-dev \
      libhdf5-serial-dev \
      build-essential \
      curl \
      unzip \
      vim \
      tmux \
      parallel \
      htop \	
      openssh-server \
      net-tools \
      texlive-xetex \
      wget && \
    rm -rf /var/lib/apt/lists/*

# Install conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

# Install Python packages and keras
ENV NB_USER keras
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown $NB_USER $CONDA_DIR -R && \
    mkdir -p /src && \
    chown $NB_USER /src

USER $NB_USER

ARG python_version=3.6

RUN conda config --append channels conda-forge
RUN conda install -y python=${python_version} && \
    pip install --upgrade pip && \
    pip install \
      sklearn_pandas \
      gffutils \
      tensorflow-gpu==1.15 \
      idx2numpy \
      cntk-gpu --ignore-installed six  && \
    conda install \
      bcolz \
      h5py \
      matplotlib \
      mkl \
      nose \
      notebook \
      Pillow \
      pandas \
      pydot \
      pygpu \
      pyyaml \
      scikit-learn \
      six \
      theano==1.0.4 \
      mkdocs \
      jupyter_nbextensions_configurator \
      jupyterthemes \			
      && \
    #git clone git://github.com/keras-team/keras.git /src && pip install -e /src[tests] && \
    pip install keras==2.3.1 && \
    conda clean -yt

RUN pip install seaborn
ADD theanorc /home/keras/.theanorc

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV PYTHONPATH='/src/:$PYTHONPATH'

USER root
RUN pip install jupyterthemes
RUN conda install -c conda-forge jupyter_contrib_nbextensions
#RUN jt -t chesterish -T -N -cellw 90% -lineh 170 -fs 11 -tfs 12 -nfs 12 -ofs 10 
#!jt -t grade3 -T -N -cellw 90% -lineh 170 -fs 11 -tfs 12 -nfs 12 -ofs 10
RUN mkdir -p /data/result
RUN chmod 777 -R /data/result
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:da6908265cef:1277cde1404e8dcce66fead85e21a01db00fe05c'" >> /root/.jupyter/jupyter_notebook_config.py

# SSH
RUN apt-get -y install openssh-server
RUN mkdir -p /var/run/sshd
RUN chmod 0755 /var/run/sshd
RUN /usr/sbin/sshd
# authorize SSH connection with root account
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN service ssh restart
EXPOSE 22
EXPOSE 7000
# change password root
RUN echo "root:root"|chpasswd
# restart ssh & bash to login as root user to the docker 
ENTRYPOINT  service ssh restart &&  bash
COPY runNotebook.sh /root/ 
RUN chmod +x /root/runNotebook.sh

