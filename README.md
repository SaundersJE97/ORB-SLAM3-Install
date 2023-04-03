# ORB-SLAM3-Install
Files to run ORB-SLAM3 from a docker container

# Dependencies
Docker

# Build Docker Container

To buildthe docker container, run the following commands
```bash
git clone https://github.com/SaundersJE97/ORB-SLAM3-Install.git
cd orb-slam3-install
docker build -t orbslam3 .
```

## Install EuRoC dataset

```bash
cd orb-slam3-install
mkdir Datasets/EuRoC
wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.zip -O Datasets/EuRoC/MH01.zip
unzip Datasets/EuRoC/MH01.zip -d Datasets/EuRoC/MH01 
rm Datasets/EuRoC/MH01.zip
```

## Ensure x11 permissions to view output of ORB-SLAM3

```bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
xhost +local:docker
```

# Run docker
```bash
cd orb-slam3-install
docker run -it --privileged --net=host --ipc=host --name="orbslam3_test_2" --gpus=all -e "DISPLAY=$DISPLAY" -e "QT_X11_NO_MITSHM=1" -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" -e "XAUTHORITY=$XAUTH" -e ROS_IP=127.0.0.1 --cap-add=SYS_PTRACE -v `pwd`/Datasets:/Datasets orbslam3
```

# Running from EuRoC dataset
Usage: ./stereo_inertial_euroc path_to_vocabulary path_to_settings path_to_sequence_folder_1 path_to_times_file_1 (path_to_image_folder_2 path_to_times_file_2 ... path_to_image_folder_N path_to_times_file_N)
```bash
./Examples/Stereo-Inertial/stereo_inertial_euroc Vocabulary/ORBvoc.txt /Examples/Stereo-Inertial/RealSense_D435i.yaml
```

# Running from a RealSense camera TODO:need to get a camera working.
Run a quick test using stereo_inertial_realsense_D435i bash script
./stereo_inertial_realsense_D435i path_to_vocabulary path_to_settings (trajectory_file_name)
```bash
./Examples/Stereo-Inertial/stereo_inertial_realsense_D435i Vocabulary/ORBvoc.txt /Examples/Stereo-Inertial/RealSense_D435i.yaml
```
