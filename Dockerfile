FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive DISPLAY=:1 VNC_PORT=5901 NOVNC_PORT=6080 DESKTOP_GEOMETRY=1280x800 DESKTOP_DEPTH=24
RUN apt-get update && apt-get install -y --no-install-recommends xfce4 xfce4-terminal dbus-x11 xterm tigervnc-standalone-server tigervnc-tools novnc websockify ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN useradd -m -s /bin/bash desktop && mkdir -p /home/desktop/.vnc && chown -R desktop:desktop /home/desktop
COPY start.sh /usr/local/bin/start-desktop
RUN chmod +x /usr/local/bin/start-desktop
EXPOSE 6080
ENTRYPOINT ["/usr/local/bin/start-desktop"]
