FROM node:12.18.3 as build
RUN apt-get -qq update && apt-get install -y libsecret-1-dev
WORKDIR /theia
COPY package.json ./package.json


RUN yarn --production
RUN yarn theia build



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
WORKDIR /theia
COPY --from=build /theia /theia
ENTRYPOINT [ "node", "/theia/src-gen/backend/main.js", "/training", "--hostname=0.0.0.0" ]