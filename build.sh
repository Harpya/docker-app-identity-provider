#!/usr/bin/env bash

if [ -z $1 ];
then
        VERSION="0.0.1"
else
        VERSION="$1"
fi


git clone https://github.com/Harpya/identity-provider.git tmp && cd tmp && git checkout master && cd ..

if [ ! -d tmp/app/var ]
then
   mkdir -p tmp/app/var 
fi

touch tmp/app/var/placeholder.txt 

docker build --tag harpya/app-identity-provider:${VERSION} .

rm -rf tmp
