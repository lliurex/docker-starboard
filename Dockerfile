FROM lliurex/i386-ubuntu:14.04
MAINTAINER M.Angel Juan <m.angel.juan@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_X11_NO_MITSHM=1
ARG REPO=http://lliurex.net/trusty
RUN apt-get update && apt-get install -y wget grep screen libglib2.0-bin x11-xserver-utils gsettings-desktop-schemas gsettings-ubuntu-schemas onboard gconf2 && apt-get clean
RUN wget -q -O /etc/apt/trusted.gpg.d/lliurex.gpg "https://github.com/lliurex/lliurex-keyring/raw/master/keyrings/lliurex-archive-keyring-gpg.gpg"
RUN echo deb [trusted=yes] $REPO trusty main universe multiverse > /etc/apt/sources.list.d/lliurex.list && apt-get update
RUN apt-get install -y libjpeg62:i386 libxtst6:i386 libusb-0.1-4:i386 libstdc++6:i386 libfreetype6:i386 libsm6:i386 libglib2.0-0:i386 libxrender1:i386 libfontconfig1:i386 libqtgui4:i386 && apt-get clean
RUN mkdir /usr/share/applications -p && mkdir /usr/share/desktop-directories -p
COPY SBS0962_LINUX/StarBoardSoftware/StarBoardSoftware_9.62_i586.deb /
RUN dpkg -i /StarBoardSoftware_9.62_i586.deb && rm /StarBoardSoftware_9.62_i586.deb && apt-get clean
#RUN apt-get install adobe-flashplugin -y
#RUN apt-get install dbus dbus-x11 pulseaudio gstreamer0.10 alsa-utils -y && apt-get clean
#RUN install -d -m755 -o pulse -g pulse /run/pulse
RUN mkdir /var/run/dbus && chown messagebus:messagebus /var/run/dbus/
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
#COPY ./conffiles/* /etc/xdg/
ENTRYPOINT [ "/docker-entrypoint.sh" ]
