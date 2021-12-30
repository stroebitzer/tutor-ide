
https://theia-ide.org/docs/composing_applications/

create package json

# deps
yarn

# build
yarn theia build

# start
yarn start /my-workspace --hostname 0.0.0.0 --port 8081

# dockerize
https://github.com/theia-ide/theia-apps/blob/master/theia-go-docker/Dockerfile

docker run --security-opt seccomp=unconfined -it --rm --init --name tutor-ide -p 3000:3000 -v "/home/hubert/git/tutor-ide/workspace:/home/project:cached" ueber/tutor-ide:0.0.1