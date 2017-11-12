#! /bin/bash
#---------------------------------------
#./configure --host=powerpc-hardhat-linux --build=i686-pc-linux-gnu --target=i686-ppc-linux-gnu --prefix=${LOCAL_BUILD_PATH} --with-boost=${BOOST_PATH} --enable-shared --with-cpp --without-tests --without-qt4 --without-c_glib --without-zlib  --without-ruby --without-python --without-libevent --without-java --without-perl --without-php --with-lua=no --enable-tutorial=no --enable-tests=no  CXXFLAGS="-DHAVE_CLOCK_GETTIME -DBOOST_SP_USE_PTHREADS" ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ac_cv_lib_ssl_SSL_ctrl=yes ac_cv_lib_crypto_BN_init=yes
#---------------------------------------
NOW=$(pwd)
THRIFT=thrift-0.10.0
APPEND=tar.gz

LOCAL_BUILD_PATH=${NOW}/ok
BOOST_PATH=${NOW}/../boost/ok
mkdir ok

download()
{
    wget http://mirror.bit.edu.cn/apache/thrift/0.10.0/thrift-0.10.0.tar.gz 
}
build_thrift()
{
    [ -f ${THRIFT}.${APPEND} ] || download || exit 1 
    tar xzf ${THRIFT}.${APPEND} ||exit 1
    cd ${THRIFT}||exit 1
    ./configure --prefix=${LOCAL_BUILD_PATH} --with-boost=${BOOST_PATH} --enable-shared --with-cpp --without-tests --without-qt4 --without-c_glib --without-zlib  --without-ruby --without-python --without-libevent --without-java --without-perl --without-php --with-lua=no  --with-nodejs=no --with-go=no --with-haxe=no --with-d=no  --enable-tutorial=no --enable-tests=no  CXXFLAGS="-DHAVE_CLOCK_GETTIME -DBOOST_SP_USE_PTHREADS" ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ac_cv_lib_ssl_SSL_ctrl=yes ac_cv_lib_crypto_BN_init=yes||exit 1
    make||exit 1
    make install||exit 1
}
build_$1
