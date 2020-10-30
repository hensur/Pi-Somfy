FROM python:3.7-buster

ENV ENABLE_MQTT="true"
ENV ENABLE_ECHO="false"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo && \
    rm -rf /var/lib/apt/lists/*

RUN pip install wheel ephem configparser Flask paho-mqtt requests

RUN mkdir -p /opt/Pi-Somfy/html
RUN mkdir -p /config

COPY defaultConfig.conf /config/pi-somfy.conf
VOLUME /config

RUN cd /tmp && \
    wget https://github.com/joan2937/pigpio/archive/master.zip && \
    unzip master.zip && \
    cd pigpio-master && \
    make && make install && rm -rf /tmp/pigpio*

COPY *.py /opt/Pi-Somfy/
COPY html /opt/Pi-Somfy/html/
COPY entrypoint.sh /bin
RUN chmod +x /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]