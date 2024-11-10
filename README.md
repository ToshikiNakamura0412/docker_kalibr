# docker_kalibr

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The docker environment for [Kalibr](https://github.com/ethz-asl/kalibr)

For more information, see [Official Wiki](https://github.com/ethz-asl/kalibr/wiki)

## Environment
### OS
- Ubuntu

### Mount
- data
  - Source: `~/data`
  - Destination: `/home/user/data`
- x11
  - Source: `/tmp/.X11-unix`
  - Destination: `/tmp/.X11-unix`

## Setup
```bash
make setup
make build
```

## Usage
### Run
```bash
docker compose up -d
docker compose exec ws <command (e.g. bash, tmux)>
```

### Execute Calibration
e.g. Camera-IMU calibration
(Before running the command, you need to download the calibration data from [here](https://github.com/ethz-asl/kalibr/wiki/downloads))
```bash
rosrun kalibr kalibr_calibrate_imu_camera \
    --target ~/data/april_6x6.yaml \
    --imu ~/data/imu_adis16448.yaml \
    --imu-models calibrated \
    --cam ~/data/cam_april-camchain.yaml \
    --bag ~/data/imu_april.bag
```

### Stop
```bash
docker compose down
```
