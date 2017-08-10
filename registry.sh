#!/bin/bash

#default values
host=localhost
port=5000
comntainer_name=registry

function usage () {
	echo -e "usage: register.sh -- --options"
	echo -e "The following options are available: \n"
	echo -e "host              hostname or ip of the machine where docker registry needs to run"
	echo -e "port              port on which docker registry needs to run"
	echo -e "name              name of the container"
}


opts=$(getopt -q --longoptions "host:,port:,container_name:" -n "getopt.sh" -- "$@");
if [ $? -ne 0 ]; then
	printf "\n"
	printf "you specified an invalid option\n\n"
	usage
	exit 1
fi
eval set -- "$opts";
while true; do
	case "$1" in
		--host)
		shift;
		if [ -n "$1" ]; then
			host="$1"
			shift
		fi
		;;
		--port)
		shift;
		if [ -n "$1" ]; then
			port="$1"
			shift
		fi
		;;
		--container_name)
		shift;
		if [ -n "$1" ]; then
			container_name=$1
			shift
		fi
		--)
		shift;
		break;
		;;
	esac
done

# check if docker is installed and running
docker -v
if [[ $? != 0 ]]; then
	echo "looks like docker is not installed, please install docker and start it before running the script"
fi

# pull and run the registry container
docker run -d -p 5000:5000 --name registry registry:2
if [[ $? !=0 ]]; then
	echo "failed to pull and run the registry container"
	exit 1
fi

if [[ ! $(docker inspect -f '{{.State.Running}}' $name) ]]; then
	echo "registry is not running, displaying logs"
	docker logs registry
fi

echo -e "registry is running, you can push your images to $host:$port"

