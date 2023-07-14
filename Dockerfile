FROM ghcr.io/hex-developer/base:latest

#RUN DEBIAN_FRONTEND=noninteractive apt install -y lxqt sddm
RUN curl -fsSL https://get.docker.com | sh
RUN DEBIAN_FRONTEND=noninteractive apt install -y xinit xorg-x11-apps openbox
RUN cp --symbolic-link /usr/lib/aarch64-linux-gnu/tegra/*.so /usr/lib/aarch64-linux-gnu
