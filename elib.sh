#region env

#region docker

# Examples:
# is_exist=$(is_docker_exist)
# if [[ $is_exist -eq 0 ]]; then
#     install_docker
# else
#     echo "docker already installed"
# fi

is_docker_exist() {
    local docker_cmd=$(which docker)
    if [ -z "$docker_cmd" ]; then
        echo 0
        return 
    fi

    echo 1
    return
}

install_docker() {
    # Only support ubuntu

    local is_exist=$(is_docker_exist)
    if [ $is_exist -eq 0 ]; then
        echo "install docker..."
        sudo apt-get install -y docker.io
        echo "already installed docker"
    fi
}

# Examples:
# is_exist=$(is_docker_compose_exist)
# if [[ $is_exist -eq 0 ]]; then
#     install_docker_compose
# else
#     echo "docker-compose already installed"
# fi

is_docker_compose_exist() {
    local docker_compose_cmd=$(which docker-compose)
    if [ -z "$docker_compose_cmd" ]; then
        echo 0
        return
    fi

    echo 1
    return
}

install_docker_compose() {
    # Only support ubuntu
    # 
    # install docker-compose, default install dir:
    #   /usr/local/docker-compose

    local is_exist=$(is_docker_compose_exist)
    if [ $is_exist -eq 0 ]; then
        echo "install docker-compose..."
        local ins_dir="/usr/local/docker-compose"
        sudo mkdir -p $ins_dir
        cd $ins_dir

        sudo curl -SL https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64 -k -o $ins_dir/docker-compose
        sudo chmod +x $ins_dir/docker-compose
        sudo ln -s $ins_dir/docker-compose /usr/local/bin/docker-compose
        echo "already installed docker-compose"
    fi
}

#endregion docker

#region nginx

# Examples:
# is_exist=$(is_nginx_exist)
# if [[ $is_exist -eq 0 ]]; then
#     install_nginx
# else
#     echo "nginx already installed"
# fi

is_nginx_exist() {
    local nginx_cmd=$(which nginx)
    if [ -z "$nginx_cmd" ]; then
        echo 0
        return
    fi

    echo 1
    return
}

install_nginx() {
    # Only support ubuntu
    
    local is_exist=$(is_nginx_exist)
    if [ $is_exist -eq 0 ]; then
        echo "install nginx..."
        sudo apt install nginx -y
        echo "already installed nginx"
    fi
}


#endregion nginx

#region rsync

# Examples:
# is_exist=$(is_rsync_exist)
# if [[ $is_exist -eq 0 ]]; then
#     install_rsync
# else
#     echo "rsync already installed"
# fi

is_rsync_exist() {
    local rsync_cmd=$(which rsync)
    if [ -z "$rsync_cmd" ]; then
        echo 0
        return
    fi

    echo 1
    return
}

install_rsync() {
    # Only support ubuntu

    local is_exist=$(is_rsync_exist)
    if [ $is_exist -eq 0 ]; then
        echo "install rsync..."
        sudo apt install rsync -y
        echo "already installed rsync"
    fi
}

#endregion rsync

#endregion env
