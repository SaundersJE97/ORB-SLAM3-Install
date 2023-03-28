FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y build-essential

# Open-CV install
# https://docs.opencv.org/4.4.0/d7/d9f/tutorial_linux_install.html
RUN apt-get install -y cmake \
    wget \
    git \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev

RUN apt-get install -y \
    python-dev \
    python-numpy \
    libpython2.7-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    #libjasper-dev \
    libdc1394-22-dev \
    freeglut3-dev \
    qtbase5-dev \
    qt5-default \
    libeigen3-dev \
    libglew-dev \
    unzip
    
# http://flummox-engineering.blogspot.com/2020/02/how-to-install-libjasper-dev-on-ubuntu.html
# libjasper isn't avaiable on ubuntu 18.04 - so need to install it
RUN wget https://github.com/mdadams/jasper/archive/version-2.0.16.tar.gz -O jasper-version-2.0.16.tar.gz && \
    tar xvf jasper-version-2.0.16.tar.gz && \
    cd jasper-version-2.0.16/ && \
    cd build && \
    cmake -G "Unix Makefiles" -H/jasper-version-2.0.16 -B/jasper-version-2.0.16/build && \
    make clean all && \
    make test && \
    cd ../..

# Installing opencv
RUN git clone https://github.com/opencv/opencv.git -b 4.4.0 && \
    git clone https://github.com/opencv/opencv_contrib.git -b 4.4.0 && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake -DWITH_QT=ON \
        -DWITH_OPENGL=ON \
        -DFORCE_VTK=ON \
        -DWITH_TBB=ON \
        -DWITH_GDAL=ON \
        -DWITH_XINE=ON \
        -DBUILD_EXAMPLES=ON .. && \
    make -j4 && \
    make install && \ 
    ldconfig

# Pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git \
    && cd Pangolin \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j \
    && make install 

RUN apt-get install git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev -y \
    && git clone https://github.com/IntelRealSense/librealsense \ 
    && cd librealsense \
    && mkdir build \
    && cd build \
    && cmake ../ \
    && make clean && make -j4 && make install

# Install ORB-SLAM3
RUN apt-get install -y libboost-all-dev libssl-dev
RUN git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git ORB_SLAM3
RUN cd ORB_SLAM3 \
    && chmod +x build.sh \
    && ./build.sh
