#! /bin/bash

NOW=$(pwd)
HTTPD=httpd-2.4.29
PHP7=php-7.1.11
PHP5=php-5.6.32
SO_NAME=web_so
WEB_SOURCE_DIR=${NOW}/../../src/web/
LIBXML=libxml2-2.9.6
APPEND=tar.gz

X86_INSTALL="/home/pan/apache/x86"
ARM_INSTALL="/home/pan/apache/arm"

download()
{
    #wget http://cn2.php.net/get/php-7.1.11.tar.gz/from/this/mirror
    wget http://cn2.php.net/get/php-5.6.32.tar.gz/from/this/mirror
}
build_php5()
{
    rm ${PHP5} -r
    rm ${X86_INSTALL}/${PHP5} -r
    [ -f ${APR}.${APPEND} ] || download
    tar xzf ${PHP5}.${APPEND}
    cd ${PHP5}
    #apt install libmysqlclient-dev
    ./configure  --prefix=${X86_INSTALL}/${PHP5} --with-apxs2=${X86_INSTALL}/${HTTPD}/bin/apxs --with-mysql=/usr --includedir=${X86_INSTALL}/${HTTPD}/include --with-config-file-path=${X86_INSTALL}/${HTTPD}/conf/extra --without-pear --disable-inline-optimization --enable-zend-multibyte=no --disable-ipv6 --without-sqlite3 --enable-dba=no --without-pdo-sqlit --enable-opcache=no --disable-pdo --disable-FEATURE --disable-rpath --enable-ftp=no --with-xmlrpc --with-libxml-dir=${X86_INSTALL}/libxml2 --enable-libxml --enable-maintainer-zts --enable-dom --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter --enable-so || exit 1
    #sudo apt install python-dev
    make || exit 1
    #如果不使用root用户，install会异常，但是并不影响使用
    make install
    cp php.ini-development ${X86_INSTALL}/${HTTPD}/conf/extra/php.ini
    cp .libs/libphp5.so ${X86_INSTALL}/${HTTPD}/modules
    cd -
    echo "install ${PHP5} X86 success"
    sleep 5
}
build_compile_so()
{
    cd ${PHP5}/ext
    ./ext_skel --extname=${SO_NAME}
    cd ${SO_NAME}
    cp ${WEB_SOURCE_DIR}/config.m4 .
    ${X86_INSTALL}/${PHP5}/bin/phpize
    cp ${WEB_SOURCE_DIR}/php_${SO_NAME}.h .
    cp ${WEB_SOURCE_DIR}/${SO_NAME}.c .
    ./configure --with-php-config=${X86_INSTALL}/${PHP5}/bin/php-config
    make LDFLAGS=-lhelloworld
    make install
    cp modules/${SO_NAME}.so ${X86_INSTALL}/${HTTPD}/modules || exit 1
    cp ${WEB_SOURCE_DIR}/php.ini ${X86_INSTALL}/${HTTPD}/conf/extra || exit 1
    #${X86_INSTALL}/${HTTPD}/bin/httpd -k restart
}
build_php5
build_compile_so
