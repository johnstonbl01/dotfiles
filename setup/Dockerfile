FROM ubuntu:latest

ARG USERNAME=blake
ARG USER_UID=1001
ARG USER_GID=$USER_UID

ENV TZ=America/Chicago
ENV ANSIBLE_LOCALHOST_WARNING=False
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG DEBIAN_FONTEND=noninteractive
RUN apt update && apt install -y software-properties-common && apt install -y curl git build-essential procps file sudo locales

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "blake:pw" | chpasswd \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER blake
WORKDIR /usr/local/bin

COPY ./*.yml ./
RUN mkdir -p ~/Library/Fonts
RUN mkdir -p ~/Library/Preferences
RUN mkdir -p ~/Library/LaunchAgents

