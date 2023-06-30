FROM ghcr.io/hex-developer/main:latest
COPY root/ /

RUN useradd -ms /bin/bash jetson
RUN echo 'jetson:jetson' | chpasswd

RUN usermod -a -G sudo jetson && usermod -aG docker jetson
