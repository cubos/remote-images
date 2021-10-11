# install docker-compose
sudo mkdir -p $HOME/.docker/cli-plugins/
sudo mv /opt/docker-compose $HOME/.docker/cli-plugins/docker-compose
sudo chown -R $USER:$USER $HOME/.docker
