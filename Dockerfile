FROM ubuntu:latest

# install
RUN apt update && \
    apt upgrade -y && \
    apt install -y wget gpg sudo systemd
RUN wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public | sudo gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg
RUN dpkg --print-architecture && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt stable main" | sudo tee /etc/apt/sources.list.d/veilid.list
RUN sudo apt update && \
    sudo apt install -y veilid-server veilid-cli

COPY entry.sh /entry.sh

# sudo -u veilid veilid-server
USER veilid

# config
VOLUME /config

# State holds the node ID etc. to persist between runs
VOLUME /root/.local/share/veilid/

# logs
VOLUME /logs

# data
VOLUME /var/db/veilid-server

ENTRYPOINT ["/bin/bash", "/entry.sh"]
