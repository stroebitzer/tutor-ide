# from https://github.com/theia-ide/theia-apps/blob/master/theia-go-docker/Dockerfile

FROM node:12.18.3 as build
RUN apt-get -qq update && apt-get install -y libsecret-1-dev
WORKDIR /theia
COPY package.json ./package.json
RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean
    
FROM node:12.18.3

# TODO install docker, curl, nmap, netstat,...

# TODO set PS1 to less confusing

# install kubectl
# TODO in a versioned way of doing things!!!
RUN apt-get install curl -y
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN apt-get -qq update && apt-get install -y libsecret-1-0

WORKDIR /theia
COPY --from=build /theia /theia

# RUN adduser --disabled-password --gecos '' theia && \
#     chmod g+rw /home && \
#     mkdir -p /home/project && \
#     chown -R theia:theia /home/theia && \
#     chown -R theia:theia /home/project
# USER theia

# TODO kubernetes config file in editable location, otherwise no namespace change possible

ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/theia/plugins  

ENTRYPOINT [ "node", "/theia/src-gen/backend/main.js", "/training", "--hostname=0.0.0.0" ]