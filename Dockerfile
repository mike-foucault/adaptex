FROM elixir:1.10.2

# Install debian packages
RUN apt-get update && apt-get install --assume-yes build-essential inotify-tools

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID docker-dev-user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID docker-dev-user

USER docker-dev-user
RUN mkdir /home/docker-dev-user/docker-workspace
WORKDIR /home/docker-dev-user/docker-workspace
