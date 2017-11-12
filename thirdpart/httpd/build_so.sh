#! /bin/bash
#---------------------------------------
# 常见错误
# 1. apache起不来，httpd.conf中加载的模块有问题，比如
# LoadModule php7_module        modules/libphp7.so
# 2. 无法调用cgi接口
# a. phpinfo()确定是否加载了自定义的模块，例如web_so
# b. 自定义so库是否放在了系统调用库文件夹
# c. php.ini中没有指明web.so库的位置
# extension=/home/pan/apache/x86/httpd-2.4.29/modules/web_so.so
# 3. 拉apache发现php的so库编译时间不匹配。。
#---------------------------------------
NOW=$(pwd)
HTTPD=httpd-2.4.29
PHP7=php-7.0.3
PHP5=php-5.6.32
SO_NAME=web_so
WEB_SOURCE_DIR=${NOW}/../../src/web/
LIBXML=libxml2-2.9.6
APPEND=tar.gz

X86_INSTALL="/home/pan/apache/x86"
ARM_INSTALL="/home/pan/apache/arm"

download_php5()
{
    wget http://cn2.php.net/get/${PHP5}.tar.gz/from/this/mirror
    mv mirror ${PHP5}.${APPEND}
}
download_php7()
{
    wget http://cn2.php.net/get/${PHP7}.tar.gz/from/this/mirror
    mv mirror ${PHP7}.${APPEND}
}
build_install_php5()
{
    rm ${PHP5} -r
    rm ${X86_INSTALL}/${PHP5} -r
    [ -f ${APR}.${APPEND} ] || download_php5
    tar xzf ${PHP5}.${APPEND}
    cd ${PHP5}
    #apt install libmysqlclient-dev
    ./configure  --prefix=${X86_INSTALL}/${PHP5} --with-apxs2=${X86_INSTALL}/${HTTPD}/bin/apxs --with-mysql=/usr --includedir=${X86_INSTALL}/${HTTPD}/include --with-config-file-path=${X86_INSTALL}/${HTTPD}/conf/extra --without-pear --disable-inline-optimization --enable-zend-multibyte=no --disable-ipv6 --without-sqlite3 --enable-dba=no --without-pdo-sqlit --enable-opcache=no --disable-pdo --disable-FEATURE --disable-rpath --enable-ftp=no --with-xmlrpc --with-libxml-dir=${X86_INSTALL}/libxml2 --enable-libxml --enable-maintainer-zts --enable-dom --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter --enable-so || exit 1
    #sudo apt install python-dev
    make || exit 1
    #如果不使用root用户，install会异常，但是并不影响使用
    make install|| exit 1
    cp php.ini-development ${X86_INSTALL}/${HTTPD}/conf/extra/php.ini|| exit 1
    cp .libs/libphp5.so ${X86_INSTALL}/${HTTPD}/modules|| exit 1
    cd -|| exit 1
    echo "install ${PHP5} X86 success"|| exit 1
    sleep 5
}
build_compile5_so()
{
    cd ${PHP5}/ext|| exit 1
    ./ext_skel --extname=${SO_NAME}|| exit 1
    cd ${SO_NAME}|| exit 1
    cp ${WEB_SOURCE_DIR}/php5/config.m4 .|| exit 1
    ${X86_INSTALL}/${PHP5}/bin/phpize|| exit 1
    cp ${WEB_SOURCE_DIR}/php5/php_${SO_NAME}.h .|| exit 1
    cp ${WEB_SOURCE_DIR}/php5/${SO_NAME}.c .|| exit 1
    ./configure --with-php-config=${X86_INSTALL}/${PHP5}/bin/php-config|| exit 1
    make LDFLAGS=-lhelloworld|| exit 1
    make install|| exit 1
    cp modules/${SO_NAME}.so ${X86_INSTALL}/${HTTPD}/modules || exit 1
    cp ${WEB_SOURCE_DIR}/php5/php.ini ${X86_INSTALL}/${HTTPD}/conf/extra || exit 1
    #${X86_INSTALL}/${HTTPD}/bin/httpd -k restart
}
build_php5()
{
    build_install_php5
    build_compile_so
}
build_install_php7()
{
    rm ${PHP7} -r
    rm ${X86_INSTALL}/${PHP7} -r
    [ -f ${APR}.${APPEND} ] || download_php7
    tar xzf ${PHP7}.${APPEND}
    cd ${PHP7}
    #apt install libmysqlclient-dev
    ./configure  --prefix=${X86_INSTALL}/${PHP7} --with-apxs2=${X86_INSTALL}/${HTTPD}/bin/apxs --with-mysql=/usr --includedir=${X86_INSTALL}/${HTTPD}/include --with-config-file-path=${X86_INSTALL}/${HTTPD}/conf/extra --without-pear --disable-inline-optimization --enable-zend-multibyte=no --disable-ipv6 --without-sqlite3 --enable-dba=no --without-pdo-sqlit --enable-opcache=no --disable-pdo --disable-FEATURE --disable-rpath --enable-ftp=no --with-xmlrpc --with-libxml-dir=${X86_INSTALL}/libxml2 --enable-libxml --enable-maintainer-zts --enable-dom --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter --enable-so || exit 1
    #sudo apt install python-dev
    make || exit 1
    #如果不使用root用户，install会异常，但是并不影响使用
    make install|| exit 1
    cp php.ini-development ${X86_INSTALL}/${HTTPD}/conf/extra/php.ini|| exit 1
    cp .libs/libphp7.so ${X86_INSTALL}/${HTTPD}/modules|| exit 1
    cd -|| exit 1
    echo "install ${PHP7} X86 success"|| exit 1
    sleep 5
}
build_compile7_so()
{
    cd ${PHP7}/ext|| exit 1
    ./ext_skel --extname=${SO_NAME}|| exit 1
    cd ${SO_NAME}|| exit 1
    cp ${WEB_SOURCE_DIR}/php7/config.m4 .|| exit 1
    ${X86_INSTALL}/${PHP7}/bin/phpize|| exit 1
    cp ${WEB_SOURCE_DIR}/php7/php_${SO_NAME}.h .|| exit 1
    cp ${WEB_SOURCE_DIR}/php7/${SO_NAME}.c .|| exit 1
    ./configure --with-php-config=${X86_INSTALL}/${PHP7}/bin/php-config|| exit 1
    make LDFLAGS=-lhelloworld|| exit 1
    make install|| exit 1
    cp modules/${SO_NAME}.so ${X86_INSTALL}/${HTTPD}/modules || exit 1
    cp ${WEB_SOURCE_DIR}/php7/php.ini ${X86_INSTALL}/${HTTPD}/conf/extra || exit 1
    #${X86_INSTALL}/${HTTPD}/bin/httpd -k restart
}

build_php7()
{
    build_install_php7
    build_compile7_so
}
$1
