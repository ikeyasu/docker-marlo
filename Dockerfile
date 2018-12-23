FROM ikeyasu/opengl:ubuntu16.04
MAINTAINER ikeyasu <ikeyasu@gmail.com>

ENV DEBIAN_FRONTEND oninteractive

############################################
# Basic dependencies
############################################
RUN apt-get update --fix-missing && apt-get install -y \
      python3-numpy python3-matplotlib python3-dev \
      python3-opengl python3-pip \
      cmake zlib1g-dev libjpeg-dev xvfb libav-tools \
      xorg-dev libboost-all-dev libsdl2-dev swig \
      git wget openjdk-8-jdk unzip \
      less vim lxterminal mesa-utils \
    && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

############################################
# Change the working directory
############################################
WORKDIR /opt

############################################
# marlo
############################################

RUN pip3 install --upgrade pip
RUN pip3 install -U malmo
RUN pip3 install -U marlo

RUN cd /opt \
    && python3 -c 'import malmo.minecraftbootstrap; malmo.minecraftbootstrap.download()' \
    && chown -R user:user MalmoPlatform/

ENV MALMO_MINECRAFT_ROOT /opt/MalmoPlatform/Minecraft
ENV MALMO_XSD_PATH /opt/MalmoPlatform/Schemas

RUN cd /opt/MalmoPlatform/Minecraft \
    && sudo -u user ./gradlew setupDecompWorkspace \
    && sudo -u user ./gradlew build

COPY launchClient.sh /opt/MalmoPlatform/Minecraft/launchClient.sh

EXPOSE 10000
ENV APP "lxterminal -e 'bash -c $MALMO_MINECRAFT_ROOT/launchClient.sh -port 10000'"
