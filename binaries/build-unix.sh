#!/bin/bash

platform='linux'

if [[ $OSTYPE == *darwin* ]]; then
    platform='osx'
fi

echo "Please be sure to install PAR::Packer"
echo "Building dp-util for platform: $platform"
pp -C -f Bleach -o $platform/dp-util ../dp-util
echo "Done!"

