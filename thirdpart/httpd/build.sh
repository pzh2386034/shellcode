#! /bin/bash

HTTPD=httpd-2.4.29
APR=apr-1.6.3
APR_UTIL=apr-util-1.6.1
APR_ICONV=apr-iconv-1.2.2
PCRE=pcre-8.41
PHP=php-7.1.11
LIBXML=libxml2-2.9.6
APPEND=tar.gz

X86_INSTALL="/home/pan/apache/x86"
ARM_INSTALL="/home/pan/apache/arm"

download()
{
    wget http://mirrors.tuna.tsinghua.edu.cn/apache//httpd/httpd-2.4.29.tar.gz
    wget http://mirrors.tuna.tsinghua.edu.cn/apache//apr/apr-1.6.3.tar.gz
    wget http://mirror.bit.edu.cn/apache//apr/apr-util-1.6.1.tar.gz
    wget http://mirror.bit.edu.cn/apache//apr/apr-iconv-1.2.2.tar.gz
    wget http://ftp.exim.llorien.org/pcre/pcre-8.41.tar.gz
    wget http://cn2.php.net/get/php-7.1.11.tar.gz/from/this/mirror
    wget http://xmlsoft.org/sources/libxml2-sources-2.9.6.tar.gz -o libxml2-2.9.6.tar.gz
}
build_install_apr_x86()
{
    [ -f ${APR}.${APPEND} ] || download
    tar xzf ${APR}.${APPEND}
    cd ${APR}
    ./configure --prefix=${X86_INSTALL}/${APR} || exit 1
    make || exit 1
    make install || exit 1
    echo "install ${APR} X86 success"
    cd -
    sleep 5
}
build_install_apricon_x86()
{
    [ -f ${APR_ICONV}.${APPEND} ] || download
    tar xzf ${APR_ICONV}.${APPEND}
    cd ${APR_ICONV}
    ./configure --prefix=${X86_INSTALL}/${APR_ICONV} --with-apr=${X86_INSTALL}/${APR} || exit 1
    make || exit 1
    make install || exit 1
    echo "install ${APR_ICONV} X86 success"
    cd -
    sleep 5
}
build_install_pcre_x86()
{
    [ -f ${PCRE}.${APPEND} ] || download
    tar xzf ${PCRE}.${APPEND}
    cd ${PCRE}
    ./configure --prefix=${X86_INSTALL}/${PCRE} --with-apr=${X86_INSTALL}/${APR} || exit 1
    make || exit 1
    make install || exit 1
    echo "install ${PCRE} X86 success"
    cd -
    sleep 5
}
build_install_aprutil_x86()
{
    [ -f ${APR_UTIL}.${APPEND} ] || download
    tar xzf ${APR_UTIL}.${APPEND}
    cd ${APR_UTIL}
    ./configure --prefix=${X86_INSTALL}/${APR_UTIL} --with-apr=${X86_INSTALL}/${APR} || exit 1
    make || exit 1
    make install || exit 1
    echo "install ${APR_UTIL} X86 success"
    cd -
    sleep 5
}
build_install_httpd_x86()
{
    [ -f ${HTTPD}.${APPEND} ] || download
    tar xzf ${HTTPD}.${APPEND}
    cd ${HTTPD}
    ./configure --prefix=${X86_INSTALL}/${HTTPD} --with-pcre=${X86_INSTALL}/${PCRE} --with-apr=${X86_INSTALL}/${APR} --with-apr-util=${X86_INSTALL}/${APR_UTIL} || exit 1
    make || exit 1
    make install || exit 1
    echo "install ${HTTPD} X86 success"
    cd -
    sleep 5
}
build_install_libxml2_x86()
{
    [ -f ${LIBXML}.${APPEND} ] || download
    tar xzf ${LIBXML}.${APPEND}
    cd ${LIBXML}
    ./configure --prefix=${X86_INSTALL}/libxml2 || exit 1
    make || exit 1
    make install || exit 1
    echo "install ${LIBXML} X86 success"
    cd -
    sleep 5
}
build_install_php_x86()
{
    [ -f ${PHP}.${APPEND} ] || download
    tar xzf ${PHP}.${APPEND}
    cd ${PHP}
    ./configure  --prefix=${X86_INSTALL}/${PHP} --with-apxs2=${X86_INSTALL}/${HTTPD}/bin/apxs --with-mysql=/usr/share/mysql --includedir=${X86_INSTALL}/${HTTPD}/include --with-config-file-path=${X86_INSTALL}/${HTTPD}/conf/extra --without-pear --disable-inline-optimization --enable-zend-multibyte=no --disable-cgi --disable-ipv6 --without-sqlite3 --disable-cli --enable-dba=no --without-pdo-sqlit --enable-opcache=no --disable-pdo --enable-test_module=no --disable-FEATURE --disable-rpath --enable-ftp=no --with-xmlrpc --with-libxml-dir=${X86_INSTALL}/libxml2 --enable-libxml --enable-maintainer-zts --enable-dom --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter || exit 1
    sudo apt install python-dev
    make || exit 1
    #如果不使用root用户，install会异常，但是并不影响使用
    make install
    echo "install ${PHP} X86 success"
    cp php.ini-development ${X86_INSTALL}/${HTTPD}/conf/extra/php.ini
    cp .libs/libphp7.so ${X86_INSTALL}/${HTTPD}/modules
    cd -
    sleep 5
}
build_config()
{
    cat >> ${X86_INSTALL}/${HTTPD}/conf/httpd.conf <<EOF
LoadModule php7_module modules/libphp7.so
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>
EOF
}
build_start()
{
    #必须有root权限
    sudo cp ${X86_INSTALL}/${HTTPD}/bin/apachectl /etc/init.d/httpd
    ${X86_INSTALL}/${HTTPD}/bin/apachectl start
}
build_install_x86()
{
    build_install_apr_x86
    build_install_apricon_x86
    build_install_aprutil_x86
    build_install_pcre_x86
    build_install_httpd_x86
    build_install_libxml2_x86
    build_install_php_x86
    build_config
}
$1
