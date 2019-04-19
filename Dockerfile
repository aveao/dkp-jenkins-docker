FROM devkitpro/devkita64:latest
MAINTAINER Ave O <fuckdocker@lasagna.dev>

# Update system and install some packages
RUN dkp-pacman -Syyu --noconfirm \
 && apt update \
 && apt upgrade \
 && apt install zip git sudo tree openjdk-8-jdk-headless -y

RUN useradd -m -d /home/jenkins -s /bin/bash jenkins \
    && echo "jenkins:jenkins" | chpasswd \
    && gpasswd -a jenkins wheel

# Enable wheel group
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install all devkitPro packages. Hacky. Based on buildservnx 4's reinstall.sh
RUN DEVKITLIBS=$(dkp-pacman -Sl dkp-libs | awk '{print $2}' | tr '\n' ' ') ; \
    DEVKITLINUX=$(dkp-pacman -Sl dkp-linux | grep -v "keyring" | awk '{print $2}' | tr '\n' ' ') ; \
    dkp-pacman -Syu $DEVKITLIBS $DEVKITLINUX --needed --noconfirm

# Default command
CMD ["echo", "No default cmd set!"]
