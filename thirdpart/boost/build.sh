#! /bin/bash 

SOURCE_NAME=boost_1_65_1
APPEND=tar.gz
path=$(pwd)
INSTALL_PATH="/home/pan/workspace/makefile_proj/thirdpart/boost/ok"
download()
{
    wget  https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz 
}
build_boost()
{
    mkdir ok
    [ -f ${SOURCE_NAME}.${APPEND} ] || download || exit 1 
    tar xzf  ${SOURCE_NAME}.${APPEND} 
    cd ${SOURCE_NAME}
    ./bootstrap.sh ||exit 1
    ./b2 --prefix=${INSTALL_PATH}  link=shared threading=multi runtime-link=shared || exit 1
    cd ..
}
build_install()
{
    echo "make install complete, install head file to system thirdpart dir"
    cp -r ${path}/${SOURCE_NAME}/boost ${path}/../../src/include
    cp ${path}/${SOURCE_NAME}/stage/lib/libboost_serialization.so ${path}/../../lib
    cp -r ${path}/${SOURCE_NAME}/boost ${path}/ok
    cp ${path}/${SOURCE_NAME}/stage/lib/* ${path}/ok
}
build_clean()
{
    rm -rf ${SOURCE_NAME}
}
build_all()
{
    build_boost
    build_install
}
build_$1
