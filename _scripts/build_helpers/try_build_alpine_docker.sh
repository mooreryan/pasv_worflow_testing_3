#!/bin/bash

# You need to run this with sudo.

tag="${1}"

old_sum=_scripts/build_helpers/pasv.opam.b3sum
new_sum=${old_sum}.new

b3sum pasv.opam > ${new_sum}

if [ -f ${old_sum} ]; then
    diff -q ${old_sum} ${new_sum}
    exit_code=$?

    if [ ${exit_code} -eq 0 ]; then
	printf "The files are the same you don't need to build docker image.\n"
    else
	printf "The files are different, you need to build docker image.\n"
	mv ${new_sum} ${old_sum}
	docker build --network=host -t "${tag}" -f Dockerfile.build_static .
    fi
else
    printf "No checksum available, you need to build docker image.\n"
    mv ${new_sum} ${old_sum}
    docker build --network=host -t "${tag}" -f Dockerfile.build_static .
fi

rm ${new_sum}
chown ryan:ryan ${old_sum}
