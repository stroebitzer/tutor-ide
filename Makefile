IMAGE_REPOSITORY = ueber
APPLICATION_NAME = tutor-ide
BUILD_VERSION = 0.0.1


.PHONY: build
build: 
	yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean

.PHONY: run
run: build
	yarn start --hostname 0.0.0.0 --port 8081

.PHONY: docker-build
docker-build: 
	docker build -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION} .

.PHONY: docker-run
docker-run: 
	docker run --security-opt seccomp=unconfined -it --rm --init --name tutor-ide -p 3000:3000 -v "/home/hubert/git/tutor-ide/workspace:/home/project:cached" ueber/tutor-ide:0.0.1

.PHONY: docker-push
docker-push: docker-build
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: k8s-patch
k8s-patch: docker-push
	kubectl rollout restart deployment tutor
	

# .PHONY: aaa-build
# aaa-build: 
# 	# yarn --production
# 	# yarn theia build
# 	yarn --pure-lockfile && \
#     NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
#     yarn theia download:plugins && \
#     yarn --production && \
#     yarn autoclean --init && \
#     echo *.ts >> .yarnclean && \
#     echo *.ts.map >> .yarnclean && \
#     echo *.spec.* >> .yarnclean && \
#     yarn autoclean --force && \
#     yarn cache clean

# .PHONY: aaa-deploy
# aaa-deploy: 
# 	zip -r theia.zip .
# 	unzip ./theia.zip -d ./fucking_fuck_fuck_nodejs

# .PHONY: aaa-run
# aaa-run: 
# 	cd ./fucking_fuck_fuck_nodejs
# 	node ./src-gen/backend/main.js /home/hubert/Desktop/fucking_theia --hostname 0.0.0.0 --port 8081
