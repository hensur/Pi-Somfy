FROM python:3.7-buster

ENV ENABLE_MQTT="true"
ENV ENABLE_ECHO="false"

RUN echo "deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi" > /etc/apt/sources.list.d/raspi.list
RUN wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add -
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo python3-pip python3-setuptools pigpio python3-pigpio python3-dev python3-wheel && \
    rm -rf /var/lib/apt/lists/*

RUN /usr/bin/python3 -m pip install wheel ephem configparser Flask paho-mqtt requests

RUN mkdir -p /opt/Pi-Somfy
RUN mkdir -p /config

COPY defaultConfig.conf /config/pi-somfy.conf
VOLUME /config

RUN cd /tmp && \
    wget https://github.com/joan2937/pigpio/archive/master.zip && \
    unzip master.zip && \
    cd pigpio-master && \
    make && make install && rm -rf /tmp/pigpio*

COPY *.py /opt/Pi-Somfy/
COPY html /opt/Pi-Somfy/
COPY entrypoint.sh /bin
RUN chmod +x /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]