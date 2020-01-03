#!/bin/bash

x11_options="\
  --device /dev/dri \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
"

graphic_options="\
  --env DISPLAY=${DISPLAY} \
  --group-add $(getent group video | cut -d: -f3)
"

sound_options="\
    --env PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    --device /dev/snd \
    --group-add $(getent group audio | cut -d: -f3) \
    --volume ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    --volume ${HOME}/.config/pulse/cookie:/root/.config/pulse/cookie \
"

xhost +local:

docker run --rm -it --net host \
  --volume "$(pwd):/var/work" \
  ${x11_options} \
  ${graphic_options} \
  ${sound_options} \
  opensiv3d \

xhost -local:
