FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS warren
ARG TAGS
RUN addgroup --gid 1000 warrenception
RUN adduser --gecos warrenception --uid 1000 --gid 1000 --disabled-password warrenception
RUN adduser warrenception sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER warrenception
WORKDIR /home/warrenception

FROM warren
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
