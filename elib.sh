#!/bin/bash

#region persistence

# copy this code to your script

# SCRIPT_NAME="elib.sh"
# LOCAL_DIR="$HOME/.local/elib"
# LOCAL_SH_PATH="$LOCAL_DIR/$SCRIPT_NAME"
# GITHUB_URL="https://raw.githubusercontent.com/CBAnother/shlib/refs/heads/main/$SCRIPT_NAME"
# VERSION_URL="https://raw.githubusercontent.com/CBAnother/shlib/refs/heads/main/version.txt"
# LOCAL_VERISON_FILE="$LOCAL_DIR/version.txt"

# mkdir -p $LOCAL_DIR

# REMOTE_VERSION=$(curl -fsSL "$VERSION_URL" || echo "unknown")
# LOCAL_VERSION=$(cat "$LOCAL_VERISON_FILE" 2>/dev/null || echo "unknown")

# if [[ ! -f "$LOCAL_SH_PATH" || "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
#     echo "Updating $SCRIPT_NAME to version $REMOTE_VERSION..."
#     curl -fsSL "$GITHUB_URL" -o "$LOCAL_SH_PATH"
#     chmod +x "$LOCAL_SH_PATH"
#     echo "$REMOTE_VERSION" > "$LOCAL_VERISON_FILE"
# else
#     echo "$SCRIPT_NAME is up to date (version $LOCAL_VERSION)"
# fi

# source "$LOCAL_SH_PATH"

#endregion persistence


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


is_docker_compose_config_exist() {
    # check docker-compose config file exist
    # Args:
    #   $1: dir

    local dir=$1
    if [ -z "$dir" ]; then
        echo 0
        return
    fi

    # check dir exist
    if [ ! -d "$dir" ]; then
        echo 0
        return
    fi

    local docker_compose_file1="$dir/docker-compose.yml"
    local docker_compose_file2="$dir/docker-compose.yaml"
    if [ -f "$docker_compose_file1" ] || [ -f "$docker_compose_file2" ]; then
        echo 1
        return
    fi

    echo 0
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


#region docker helper

docker_is_container_exist() {
    # check docker container exist
    # 
    # Args:
    #   $1: container name
    #
    # Return:
    #   0: not exist
    #   1: exist
    #
    # Example:
    # is_exist=$(docker_is_container_exist "nginx")
    # if [[ $is_exist -eq 1 ]]; then
    #     echo "nginx exist"
    # fi
    
    local name=$1
    local container_name

    container_name=$(docker ps -a --filter "name=$name" --format "{{.Names}}")

    if [[ -z "$container_name" ]]; then
        echo 0
        return 
    else
        # 使用 bash 内建的变量比较，确保完全匹配
        if [[ "$container_name" == "$name" ]]; then
            echo 1
            return 
        else
            echo 0
            return 
        fi
    fi
}

docker_is_container_running() {
    # check docker container is running
    # if container not exist, return 0
    # 
    # Args:
    #   $1: container name
    # 
    # Return:
    #   0: not running
    #   1: running
    # 
    # Example:
    # is_running=$(docker_is_container_running "nginx")
    # if [[ $is_running -eq 1 ]]; then
    #     echo "nginx is running"
    # fi
    
    local name=$1
    local container_name
    
    local exist=$(docker_is_container_exist $name)
    if [[ exist -eq 0 ]]; then
        echo 0
        return 
    fi

    # 仅查询正在运行的容器
    container_name=$(docker ps --filter "name=$name" --format "{{.Names}}")

    if [[ -z "$container_name" ]]; then
        echo 0
        return 
    else
        # 确保名称完全匹配
        if [[ "$container_name" == "$name" ]]; then
            echo 1
            return 
        else
            echo 0
            return 
        fi
    fi
}

docker_list_containers() {
    # list all containers
    #
    # Args:
    #   $1: only running, default is false
    #       true: only running
    #       false: all
    #
    # Return:
    #  container names
    # 
    # Example:
    # containers=$(docker_list_containers)
    # for container in $containers; do
    #     echo "container name: $container"
    # done

    local only_running=$1
    local format="{{.Names}}"

    if [[ "$only_running" == "true" ]]; then
        docker ps --format "$format"
    else
        docker ps -a --format "$format"
    fi
}

#endregion docker helper


#region filesystem

list_files() {
    # list all files in the dir
    # 
    # Args:
    #   $1: dir
    #   [option] $2: file type, default is all
    #       *: all
    #   [option] $3: is recursive, default is false
    #       true: recursive
    #       false: not recursive

    local dir=$1
    local file_type=$2
    local is_recursive=$3

    if [ -z "$file_type" ]; then
        file_type="*"
    fi

    if [ -z "$is_recursive" ]; then
        is_recursive=false
    fi

    if [ "$is_recursive" = true ]; then
        find $dir -name "*.$file_type"
    else
        ls $dir/*.$file_type
    fi
}

print_files() {
    # print all files in the dir
    # 
    # Args:
    #   $1: dir
    #   [option] $2: file type, default is all
    #       *: all
    #   [option] $3: is recursive, default is false
    #       true: recursive
    #       false: not recursive

    local files=$(list_files $1 $2 $3)
    local no=1
    for file in $files; do
        echo "$no: $file"
        no=$((no+1))
    done
}

count_files() {
    # count files in the dir
    # 
    # Args:
    #   $1: dir
    #   [option] $2: file type, default is all
    #       *: all
    #   [option] $3: is recursive, default is false
    #       true: recursive
    #       false: not recursive

    local dir=$1
    if [ -z "$dir" ]; then
        echo 0
        return
    fi

    # check dir exist
    if [ ! -d "$dir" ]; then
        echo 0
        return
    fi

    local files=$(list_files $1 $2 $3)
    local count=0
    for file in $files; do
        count=$((count+1))
    done

    echo $count
}

#endregion filesystem


#region log

# default INFO
LOG_LEVEL=1

declare -A LOG_LEVELS=(
    ["DEBUG"]=0
    ["INFO"]=1
    ["WARN"]=2
    ["ERROR"]=3
)

log() {
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local BLUE='\033[0;34m'
    local NC='\033[0m' # No Color

    local level=$1
    shift
    local msg="$@"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # 检查日志级别，如果当前级别 < 设定的 LOG_LEVEL，则不输出
    if [[ ${LOG_LEVELS[$level]} -lt $LOG_LEVEL ]]; then
        return
    fi

    case "$level" in
        INFO)
            echo -e "${GREEN}[INFO] ${timestamp} - ${msg}${NC}"
            ;;
        WARN)
            echo -e "${YELLOW}[WARN] ${timestamp} - ${msg}${NC}"
            ;;
        ERROR)
            echo -e "${RED}[ERROR] ${timestamp} - ${msg}${NC}"
            ;;
        DEBUG)
            echo -e "${BLUE}[DEBUG] ${timestamp} - ${msg}${NC}"
            ;;
        *)
            echo -e "[UNKNOWN] ${timestamp} - ${msg}"
            ;;
    esac
}

#endregion log