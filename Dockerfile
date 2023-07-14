FROM ghcr.io/hex-developer/base:latest

#RUN DEBIAN_FRONTEND=noninteractive apt install -y lxqt sddm
RUN curl -fsSL https://get.docker.com | sh
RUN DEBIAN_FRONTEND=noninteractive apt install -y xinit x11-apps openbox
RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvrm.so /usr/lib/aarch64-linux-gnu/ && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvll.so /usr/lib/aarch64-linux-gnu/ && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvos.so /usr/lib/aarch64-linux-gnu/ && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvrm_graphics.so /usr/lib/aarch64-linux-gnu/ && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvdc.so /usr/lib/aarch64-linux-gnu/ && \
    ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvimp.so /usr/lib/aarch64-linux-gnu/ && \
