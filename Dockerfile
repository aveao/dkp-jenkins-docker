FROM archlinux/base:latest
MAINTAINER Ave O <fuckdocker@lasagna.dev>

COPY pacman.conf /etc/pacman.conf

RUN  chmod 644 /etc/pacman.conf && chown root:root /etc/pacman.conf

# start up keyring and install DKP keyring
RUN pacman-key --init && pacman-key --populate archlinux \
  cd /tmp ; \
  curl https://downloads.devkitpro.org/devkitpro-keyring-r1.787e015-2-any.pkg.tar.xz > dkp-keyring.tar.xz ; \
  pacman -U dkp-keyring.tar.xz --noconfirm --needed

# Update system and install some packages
RUN pacman -Syyu --noconfirm \
 && pacman -S --noconfirm --needed base-devel git wget nano sudo \
    openssh ccache iputils iproute2 jshon xdelta3 tree jdk8-openjdk

# Replace gcc with gcc-multilib
RUN echo -e "y\ny\ny" | sudo pacman -S gcc-multilib

RUN rm -rf /var/cache/pacman/pkg/*

RUN useradd -m -d /home/jenkins -s /bin/bash jenkins \
    && echo "jenkins:jenkins" | chpasswd \
    && gpasswd -a jenkins wheel

# Enable wheel group
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install cower and trizen
RUN  \
  sudo -u jenkins gpg --keyserver 'hkp://pgp.mit.edu'  --recv-keys 1EB2638FF56C0C53 ; \
  cd /tmp ; \
  sudo -u jenkins wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz ; \
  sudo -u jenkins tar -xzf cower.tar.gz ; \
  cd ./cower ; \
  sudo -u jenkins makepkg -si --noconfirm --needed ; \
  cd .. ; \
  sudo -u jenkins wget https://aur.archlinux.org/cgit/aur.git/snapshot/trizen.tar.gz ; \
  sudo -u jenkins tar -xzf trizen.tar.gz ; \
  cd ./trizen ; \
  sudo -u jenkins makepkg -si --noconfirm --needed

# Install all devkitPro packages. Hacky. Based on buildservnx 4's reinstall.sh
RUN DEVKITLIBS=$(pacman -Sl dkp-libs | awk '{print $2}' | tr '\n' ' ') ; \
    DEVKITLINUX=$(pacman -Sl dkp-linux | grep -v "keyring" | awk '{print $2}' | tr '\n' ' ') ; \
    pacman -Syu $DEVKITLIBS $DEVKITLINUX --noconfirm

# Default command
CMD ["echo", "No default cmd set!"]
