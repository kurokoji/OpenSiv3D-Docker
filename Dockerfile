FROM archlinux/base

LABEL version=1.0
MAINTAINER Shu Kakihana <shu.kakihana@gmail.com>

RUN echo 'Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN pacman -Sy
RUN pacman -S --noconfirm base-devel git glew opencv libpng libjpeg-turbo giflib libwebp
RUN pacman -S --noconfirm freetype2 harfbuzz openal libogg  libvorbis boost glib2 ffmpeg vtk hdf5 xorg cmake ninja qt5-base pulseaudio

RUN useradd -m builder && \
    echo 'builder ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/makepkg

RUN mkdir -p /builds/output
RUN chmod -R 777 /builds
WORKDIR /builds

USER builder

# angelscript
RUN git clone --depth 1 https://aur.archlinux.org/angelscript.git
WORKDIR /builds/angelscript
RUN makepkg -si --noconfirm

# OpenSiv3D
WORKDIR /builds
RUN git clone --depth 1 https://github.com/Siv3D/OpenSiv3D.git

WORKDIR /builds/OpenSiv3D/Linux
RUN mkdir Build
WORKDIR /builds/OpenSiv3D/Linux/Build
RUN cmake -GNinja .. && ninja

WORKDIR /builds/OpenSiv3D/Linux/App
COPY ./src/ /builds/OpenSiv3D/Linux/App/src
COPY ./include/ /builds/OpenSiv3D/Linux/App/include
COPY CMakeLists.txt /builds/OpenSiv3D/Linux/App
RUN mkdir Build
WORKDIR /builds/OpenSiv3D/Linux/App/Build
RUN cmake -GNinja .. && ninja && cp Siv3D_App ..

WORKDIR /builds/OpenSiv3D/Linux/App
CMD ["./Siv3D_App"]
