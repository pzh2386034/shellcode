#! /bin/bash

HTTPD=httpd-2.4.29
APR=apr-1.6.3
APR_UTIL=apr-util-1.6.1
APR_ICONV=apr-iconv-1.2.2
PCRE=pcre-8.41
PHP7=php-7.1.11
PHP5=php-5.6.32
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
    wget http://cn2.php.net/get/php-5.6.32.tar.gz/from/this/mirror
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
build_install_php7_x86()
{
    [ -f ${PHP7}.${APPEND} ] || download
    tar xzf ${PHP7}.${APPEND}
    cd ${PHP7}
    ./configure  --prefix=${X86_INSTALL}/${PHP7} --with-apxs2=${X86_INSTALL}/${HTTPD}/bin/apxs --with-mysql=/usr/share/mysql --includedir=${X86_INSTALL}/${HTTPD}/include --with-config-file-path=${X86_INSTALL}/${HTTPD}/conf/extra --without-pear --disable-inline-optimization --enable-zend-multibyte=no --disable-ipv6 --without-sqlite3 --enable-dba=no --without-pdo-sqlit --enable-opcache=no --disable-pdo --disable-FEATURE --disable-rpath --enable-ftp=no --with-xmlrpc --with-libxml-dir=${X86_INSTALL}/libxml2 --enable-libxml --enable-maintainer-zts --enable-dom --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter --enable-so || exit 1
    #sudo apt install python-dev
    make || exit 1
    #如果不使用root用户，install会异常，但是并不影响使用
    make install
    echo "install ${PHP7} X86 success"
    cp php.ini-development ${X86_INSTALL}/${HTTPD}/conf/extra/php.ini
    cp .libs/libphp7.so ${X86_INSTALL}/${HTTPD}/modules
    cd -
    sleep 5
}
build_install_php5_x86()
{
    [ -f ${PHP5}.${APPEND} ] || download
    tar xzf ${PHP5}.${APPEND}
    cd ${PHP5}
    #apt install libmysqlclient-dev
    ./configure  --prefix=${X86_INSTALL}/${PHP5} --with-apxs2=${X86_INSTALL}/${HTTPD}/bin/apxs --with-mysql=/usr --includedir=${X86_INSTALL}/${HTTPD}/include --with-config-file-path=${X86_INSTALL}/${HTTPD}/conf/extra --without-pear --disable-inline-optimization --enable-zend-multibyte=no --disable-ipv6 --without-sqlite3 --enable-dba=no --without-pdo-sqlit --enable-opcache=no --disable-pdo --disable-FEATURE --disable-rpath --enable-ftp=no --with-xmlrpc --with-libxml-dir=${X86_INSTALL}/libxml2 --enable-libxml --enable-maintainer-zts --enable-dom --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter --enable-so || exit 1
    #sudo apt install python-dev
    make || exit 1
    #如果不使用root用户，install会异常，但是并不影响使用
    make install
    echo "install ${PHP5} X86 success"
    cp php.ini-development ${X86_INSTALL}/${HTTPD}/conf/extra/php.ini
    cp .libs/libphp5.so ${X86_INSTALL}/${HTTPD}/modules
    cd -
    sleep 5
}
build_add_virtualNet()
{
    sudo cat >> /etc/network/interfaces <<EOF
auto eth0:0
iface eth0:0 inet static
address 192.168.100.10
netmask 255.255.255.0
#network 192.168.10.1
#broadcast 192.168.1.255
EOF
    sudo /etc/init.d/networking restart
}
build_config()
{
    cat >> ${X86_INSTALL}/${HTTPD}/conf/httpd.conf <<EOF
LoadModule php7_module modules/libphp7.so
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>
EOF
    #如果使用无线网络，则需要配置虚拟网卡，打开以下操作
    ##临时添加虚拟网卡
    #sudo ifconfig eth0:0 192.168.100.10 up
    #build_add_virtualNet
    #sed -n '/^Liston 80/p' ${X86_INSTALL}/${HTTPD}/conf/http.conf | sed 's/80/192.168.100.10:80/g'
}

build_start()
{
    #必须有root权限
    sudo cp ${X86_INSTALL}/${HTTPD}/bin/apachectl /etc/init.d/httpd
    sudo ${X86_INSTALL}/${HTTPD}/bin/apachectl start
}
build_install_x86()
{
    build_install_apr_x86
    build_install_apricon_x86
    build_install_aprutil_x86
    build_install_pcre_x86
    build_install_httpd_x86
    build_install_libxml2_x86
    build_install_php5_x86
    build_config
}
$1
