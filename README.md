## gpu-Docker
This docker is build to run the Keras based on GPU, Jupyter notebook, and root access to the shell via SSH.

---

Most machine learning researchers/ engineers/data scientists need to train the model with a different version of software/ libraries—this process ending with the installation lot of packages and solve the dependency, and spend more time.

This docker runs Keras version 2.3 based on GPU that uses Nvidia-docker and has access to Jupyter notebook. Besides, you can connect by ssh to the same docker and use the Linux commands as a root user. 

This is useful because you don't need to stop the Jupyter or use '!' from the notebook to install Linux software or python packages. 

Here is the list of some softwares included in the docker:

---

| Software/ packages | version/ comments |
|--------------------|-------------------|
| Ubuntu             | 18.04             |
| Python             | 3.6               |
| CUDA               | 10.0              |
| CUDNN              | 7                 |
| tensorflow-gpu     | 1.15              |
| keras              | 2.3.1             |

Final image size ~10GB 

---

### Installation 
1- You need to have nvidia/cuda docker to use the GPU. here is the link you can follow to install it:
https://github.com/NVIDIA/nvidia-docker

---

### Runing the Docker container

Be sure you installed the Nvidia/cuda docker in your system. 

```bash
# git clone https://github.com/shahryary/gpuDocker
# cd gpuDocker
```
The default virtual directory is mounted as '/storage' point inside the docker container; by default, your current directory is the path to that mount point.

For instance, if you want to use any directory from your local system in the docker, you should change 'SRC' option in the 'Makefile' file.
SRC?="/home/yadi/myData" 
So, I can access 'myData' folder from the local computer in docker container at "/storage" point.

Then run this command to start the container:
```bash
# make bash GPU=0
```

Wait for a couple of minutes to build the docker container from the Docker file. If everything went well, you shoul be login as root user in the container. 

To start the Jupyter run this command: 
```
# ./root/runNotebook.sh
```
After starting the Jupyter you can access it from your browser: 
``` bash 
# http://YOUR-IP-Address:7000
# The default password is: jupyter
```
The default port for the Jupyter is 7000 and 20 for SSH login, and you could modify this option from the DockerFile. 

***Note: be sure those ports are open if you are using Firewall in your local system.***

You can log in by SSH in another terminal, so you don't need to stop the Jupyter installing or managing the software. 

open another terminal and connect to the container:
```
# ssh root@YOUR-IP-Address -p 20
```
**The default password is 'root'**


If you need specific software/ packages, feel free to modify the DockerFile and after that, just use "make bash GPU=0" to build the new image.