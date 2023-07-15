#!/usr/bin/env bash
# Script run.sh runs your Docker container.

if command -v gdate &>/dev/null
then
	datecmd=gdate
else
	datecmd=date
fi

IMAGE=${IMAGE:-mbigras/app:$($datecmd --rfc-3339=date)}

if ! docker inspect "$IMAGE" &>/dev/null
then
	SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd) # for an explanation about this arcane command, see https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script/246128#246128 answer.
	IMAGE="$IMAGE" "${SCRIPT_DIR}/build.sh"
fi

docker rm --force app &>/dev/null

docker run \
	--name=app \
	--detach \
	--env="ENV=example" \
	--env="COLOR=brightpurple" \
	--env="PASSWORD=password123" \
	--env="FEATURE1=on" \
	--env="FEATURE2=on" \
	"$IMAGE" &>/dev/null

docker run \
	--rm \
	--network="container:app" \
	curlimages/curl \
	curl --silent --retry-all-errors --retry 3 localhost:8080

docker rm --force app &>/dev/null
