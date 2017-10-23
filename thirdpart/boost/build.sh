#! /bin/bash

SOURCE_NAME=boost_1_65_1
APPEND=tar.gz
PATH=$(pwd)
INSTALL_HEAD_PATH="/home/pan/workspace/makefile_proj/thirdpart/boost/"
INSTALL_LIB_PATH="${PATH}/../../lib"
tar xzf  ${SOURCE_NAME}.${APPEND} 
download()
{
    wget  https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz 
}
build_boost()
{
    [ -f ${SOURCE_NAME}.${APPEND} ] || download || exit 1 
    cd ${SOURCE_NAME}
    ./bootstrap.sh ||exit 1
    ./b2 --includedir=${INSTALL_HEAD_PATH} --libdir=${INSTALL_LIB_PATH} link=shared threading=multi runtime-link=shared || exit 1
    make || exit 1
    make install || exit 1
    cd ..
}
build_install()
{
    echo "make install complete, install head file to system thirdpart dir"
    cp ${INSTALL_PATH}/include /home/pan/thirdpart_head/boost/
}
build_clean()
{
    rm -rf ${SOURCE_NAME}
}
build_all()
{
    build_boost
    build_clean
}
build_$1
