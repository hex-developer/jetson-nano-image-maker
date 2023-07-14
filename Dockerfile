FROM ghcr.io/hex-developer/base:latest

#RUN DEBIAN_FRONTEND=noninteractive apt install -y lxqt sddm
RUN curl -fsSL https://get.docker.com | sh
RUN DEBIAN_FRONTEND=noninteractive apt install -y xinit x11-apps openbox
COPY symlink.sh symlink.sh
RUN chmod +x symlink.sh && ./symlink.sh && rm -rf symlink.sh
