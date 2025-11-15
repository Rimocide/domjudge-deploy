#!/usr/bin/env bash

docker pull mariadb
docker pull domjudge/judgehost
docker pull domjudge/domserver

if [[ "$1" == "-i" && -z "$2" ]]; then
  docker run -it --name dj-mariadb -e MYSQL_ROOT_PASSWORD=rootpw -e MYSQL_USER=domjudge -e MYSQL_PASSWORD=djpw -e MYSQL_DATABASE=domjudge -p 13306:3306 mariadb --max-connections=1000

  docker run --link dj-mariadb:mariadb -it -e MYSQL_HOST=mariadb -e MYSQL_USER=domjudge -e MYSQL_DATABASE=domjudge -e MYSQL_PASSWORD=djpw -e MYSQL_ROOT_PASSWORD=rootpw -p 12345:80 --name domserver domjudge/domserver:latest

  docker run -it --privileged -v /sys/fs/cgroup:/sys/fs/cgroup --name judgehost-0 --link domserver:domserver --hostname judgedaemon-0 -e DAEMON_ID=0 domjudge/judgehost:latest

elif [[ "$1" == "-i" && -n "$2" ]]; then
  awk number of judgehosts from second arg

elif [ "$1" == "-sp" ]; then
  docker stop $(docker ps -q)

elif [ "$1" == "-st" ]; then
  docker start $(docker ps -aq --filter "status=exited")


fi
