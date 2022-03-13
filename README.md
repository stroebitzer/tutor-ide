# build
yarn
yarn theia build

# run
yarn start --hostname 0.0.0.0 --port 8081

# install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn

yarn --version
1.22.17