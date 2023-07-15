#!/usr/bin/env bash
# Script build.sh builds your Docker image.

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd) # for an explanation about this arcane command, see https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script/246128#246128 answer.

if command -v gdate &>/dev/null
then
	datecmd=gdate
else
	datecmd=date
fi

IMAGE=${IMAGE:-mbigras/app:$($datecmd --rfc-3339=date)}

docker build --tag="$IMAGE" "$SCRIPT_DIR" && echo "$IMAGE"
