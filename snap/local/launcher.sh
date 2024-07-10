#!/bin/bash -e

source $SNAP/usr/bin/utils.sh

# Iterate over the snap parameters and retrieve their value.
# If a value is set, it is forwarded to the launch file.

OPTIONS=(
  name
  parent-frame
  camera-model
  cam-pos-x
  cam-pos-y
  cam-pos-z
  cam-roll
  cam-pitch
  cam-yaw
  params-file
)

LAUNCH_OPTIONS=""

for OPTION in "${OPTIONS[@]}"; do
  VALUE="$(snapctl get driver.${OPTION})"
  if [ -n "${VALUE}" ]; then
    OPTION_WITH_UNDERSCORE=$(echo ${OPTION} | tr - _)
    LAUNCH_OPTIONS+="${OPTION_WITH_UNDERSCORE}:=${VALUE} "
  fi
done

if [ "${LAUNCH_OPTIONS}" ]; then
  # watch the log with: "journalctl -t husarion-depthai"
  log_and_echo "Running with options: ${LAUNCH_OPTIONS}"
fi

ros2 launch $SNAP/usr/bin/depthai.launch.py ${LAUNCH_OPTIONS} ffmpeg_params_file:=$SNAP_COMMON/ffmpeg_params.yaml
