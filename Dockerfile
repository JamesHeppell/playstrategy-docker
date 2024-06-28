FROM debian:buster-20210816-slim

SHELL ["/bin/bash", "-c"]

RUN useradd -ms /bin/bash playstrategy \
    && apt-get update \
    && apt update \
    && apt-get install -y sudo gnupg \
    # Disable sudo login for the new lichess user.
    && echo "playstrategy ALL = NOPASSWD : ALL" >> /etc/sudoers

ENV TZ=Etc/GMT
RUN sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && sudo echo $TZ > /etc/timezone

# Run as a non-privileged user.
USER playstrategy

ADD build /home/playstrategy/build

# mongodb
RUN sudo apt-key add /home/playstrategy/build/signatures/mongodb.asc \
  && echo "deb https://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org.list

RUN sudo apt-get update && sudo apt update \
  && sudo apt-get install -y \
  unzip \
  zip \
  curl \
  mongodb-org \ 
  parallel \ 
  && sudo apt install -y \ 
  redis-server \
  git-all \
  vim \
  build-essential

# nvm => node => pnpm
RUN source /home/playstrategy/build/nvm-install.sh \
  && export NVM_DIR="$HOME/.nvm" \
  && source "$NVM_DIR/nvm.sh" \
  && nvm install 16 \
  && npm install -g yarn

# Java
RUN /home/playstrategy/build/sdkman-init.sh \
  && source /home/playstrategy/.sdkman/bin/sdkman-init.sh \
  && sdk install java 17.0.5-tem && sdk install sbt

# Silence the parallel citation warning.
RUN sudo mkdir -p ~/.parallel && sudo touch ~/.parallel/will-cite

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

# Make directories for mongodb
RUN sudo mkdir -p /data/db && sudo chmod 666 /data/db

# Cleanup
RUN sudo apt-get autoremove -y \
  && sudo apt-get clean \
  && sudo rm -rf /home/playstrategy/build

ADD run.sh /home/playstrategy/run.sh

# Use UTF-8 encoding.
ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

WORKDIR /home/playstrategy

ENTRYPOINT ./run.sh
