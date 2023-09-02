FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    xterm \
    novnc \
    websockify

################# bg update ###################

COPY assets/bg-l2.png /usr/share/backgrounds/xfce/xfce-verticals.png

################ adding user #################

RUN useradd -ms /bin/bash abhishek
RUN echo 'abhishek:mypassword' | chpasswd

################ adding sudo permission ###################

RUN apt-get update \
    && apt-get install -y sudo \
    && echo 'abhishek ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/list/*

################ Installing audio drivers #######################

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        alsa-base \
        alsa-utils \
        libsndfile1-dev


################## depriortize snapd in firefox ###################
RUN apt install software-properties-common -y

COPY src/firefox-installation.sh /opt/firefox-installation.sh

RUN add-apt-repository ppa:mozillateam/ppa -y

RUN bash /opt/firefox-installation.sh

RUN apt install firefox -y

############### installing vscode and #######################

COPY src/vscode-repo.sh /opt/vscode-repo.sh

RUN bash /opt/vscode-repo.sh

RUN apt install apt-transport-https -y && \
 apt update && \
 apt install code -y


################ install few custom tools ####################
RUN apt install curl python3 python3-pip python3-cairo alacarte -y

RUN apt install git tmux language-pack-en vim nano -y

RUN add-apt-repository ppa:mmk2410/intellij-idea -y
RUN apt update && apt install -y openjdk-18-jre && apt install intellij-idea-community -y



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
