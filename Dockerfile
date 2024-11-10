ARG ROS_DISTRO=noetic
FROM osrf/ros:${ROS_DISTRO}-desktop-full
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# ===================
# Basic installation
# ===================
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
	&& apt-get update \
	&& apt-get install -y sudo git vim tmux \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
	&& chmod 0440 /etc/sudoers.d/$USERNAME
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y --no-install-recommends \
	ros-${ROS_DISTRO}-desktop \
	python3-catkin-tools
RUN rm -rf /var/lib/apt/lists/*
RUN rm /etc/apt/apt.conf.d/docker-clean

# ================================
# Install apt packages for Kalibr
# ================================
# Dependencies we use, catkin tools is very good build system
# https://github.com/ethz-asl/kalibr/wiki/installation
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	git wget autoconf automake nano \
	python3-dev python3-pip python3-scipy python3-matplotlib \
	ipython3 python3-wxgtk4.0 python3-tk python3-igraph python3-pyx \
	libeigen3-dev libboost-all-dev libsuitesparse-dev \
	doxygen \
	libopencv-dev \
	libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev \
	python3-catkin-tools python3-osrf-pycommon

# ============
# Change user
# ============
USER $USERNAME
ENV SHELL /bin/bash

# ======
# Setup
# ======
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source ~/ws/devel/setup.bash" >> ~/.bashrc
RUN echo "export ROS_DISTRO=${ROS_DISTRO}" >> ~/.bashrc
RUN echo "export ROS_WORKSPACE=~/ws" >> ~/.bashrc
RUN echo "export ROS_PACKAGE_PATH=~/ws/src:\$ROS_PACKAGE_PATH" >> ~/.bashrc

# =============
# Build Kalibr
# =============
RUN mkdir -p ~/ws/src && git clone https://github.com/ethz-asl/kalibr.git ~/ws/src/kalibr
RUN cd ~/ws && /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && catkin build -j$(nproc)"

CMD ["/bin/bash"]
