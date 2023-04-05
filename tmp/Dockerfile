FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        xfce4 xfce4-goodies tightvncserver novnc websockify && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y xvfb
RUN apt-get update && apt-get install -y openssl

# Set VNC password
RUN mkdir ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

COPY novnc.pem /etc/ssl/novnc.pem
# Start NoVNC and websockify
CMD mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    Xvfb :1 -screen 0 1024x768x16 -ac & \
    sleep 2 && \
    x11vnc -display :1 -rfbport 5900 -usepw -forever & \
    cd /usr/share/novnc/utils && \
    ./launch.sh --vnc localhost:5900 --cert /etc/ssl/novnc.pem --listen 8080
