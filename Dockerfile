# from https://github.com/theia-ide/theia-apps/blob/master/theia-go-docker/Dockerfile

FROM node:12.18.3 as theia
RUN apt-get -qq update && apt-get install -y libsecret-1-dev
WORKDIR /home/theia
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
# install kubectl    
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

# install docker, curl, nmap, netstat,...


FROM node:12.18.3
RUN apt-get -qq update && apt-get install -y libsecret-1-0
COPY --from=theia /home/theia /home/theia
WORKDIR /home/theia
# RUN adduser --disabled-password --gecos '' theia && \
#     chmod g+rw /home && \
#     mkdir -p /home/project && \
#     chown -R theia:theia /home/theia && \
#     chown -R theia:theia /home/project
# USER theia
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins  

COPY settings.json /root/settings.json

ENTRYPOINT [ "node", "/home/theia/src-gen/backend/main.js", "/home/project", "--hostname=0.0.0.0" ]