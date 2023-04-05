FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    xterm \
    novnc \
    websockify

################# bg update ###################

# RUN apt install xwallpaper -y

COPY assets/newbg.png /usr/share/backgrounds/xfce/xfce-verticals.png

# RUN xwallpaper --zoom /usr/share/backgrounds/bg_default.png
################ adding user #################

RUN useradd -ms /bin/bash abhishek
RUN echo 'abhishek:mypassword' | chpasswd

################ adding sudo permission ###################

RUN apt-get update \
    && apt-get install -y sudo \
    && echo 'abhishek ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/list/*

################## depriortize snapd in firefox ###################
RUN apt install software-properties-common -y

COPY script.sh /script.sh

RUN add-apt-repository ppa:mozillateam/ppa -y

RUN bash /script.sh

RUN apt install firefox -y

############### installing vscode and #######################

COPY vscode.sh /vscode.sh

RUN bash /vscode.sh

RUN apt install apt-transport-https -y && \
 apt update && \
 apt install code -y


################ install few custom tools ####################
RUN apt install curl python3 python3-pip python3-cairo alacarte -y

# RUN systemctl enable snapd

USER abhishek
WORKDIR /home/abhishek

RUN mkdir .vnc

RUN echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 0600 ~/.vnc/passwd

RUN echo "#!/bin/bash\n\nxrdb ~/.Xresources\nstartxfce4 &\n" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup


ENV USER user

EXPOSE 5901
EXPOSE 6080
ADD novnc.pem /etc/ssl/novnc.pem
CMD ["sh", "-c", "vncserver -depth 24 -geometry 1920x1080 :1 && websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 6080 localhost:5901 && tail -f /dev/null"]