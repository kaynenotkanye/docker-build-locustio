FROM python:3.8.10-buster

RUN apt update -y

RUN apt install python3-pip -y

RUN pip3 install --upgrade pip

RUN pip3 install --no-cache-dir git+https://github.com/locustio/locust.git@0.14.6#egg=locustio

RUN pip3 install numpy==1.16.4

RUN pip3 install greenlet==0.4.16

RUN mkdir /locust

WORKDIR /locust

EXPOSE 8089 5557 5558

ENTRYPOINT ["/locust/entrypoint.sh"]
