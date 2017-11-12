dnl $Id$
dnl config.m4 for extension web_so

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

dnl PHP_ARG_WITH(web_so, for web_so support,
dnl Make sure that the comment is aligned:
dnl [  --with-web_so             Include web_so support])

dnl Otherwise use enable:

PHP_ARG_ENABLE(web_so, whether to enable web_so support,
dnl Make sure that the comment is aligned:
[  --enable-web_so           Enable web_so support])

if test "$PHP_WEB_SO" != "no"; then
  dnl Write more examples of tests here...

  dnl # --with-web_so -> check with-path
  dnl SEARCH_PATH="/usr/local /usr"     # you might want to change this
  dnl SEARCH_FOR="/include/web_so.h"  # you most likely want to change this
  dnl if test -r $PHP_WEB_SO/$SEARCH_FOR; then # path given as parameter
  dnl   WEB_SO_DIR=$PHP_WEB_SO
  dnl else # search default path list
  dnl   AC_MSG_CHECKING([for web_so files in default path])
  dnl   for i in $SEARCH_PATH ; do
  dnl     if test -r $i/$SEARCH_FOR; then
  dnl       WEB_SO_DIR=$i
  dnl       AC_MSG_RESULT(found in $i)
  dnl     fi
  dnl   done
  dnl fi
  dnl
  dnl if test -z "$WEB_SO_DIR"; then
  dnl   AC_MSG_RESULT([not found])
  dnl   AC_MSG_ERROR([Please reinstall the web_so distribution])
  dnl fi

  dnl # --with-web_so -> add include path
  dnl PHP_ADD_INCLUDE($WEB_SO_DIR/include)

  dnl # --with-web_so -> check for lib and symbol presence
  dnl LIBNAME=web_so # you may want to change this
  dnl LIBSYMBOL=web_so # you most likely want to change this 

  dnl PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  dnl [
  dnl   PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $WEB_SO_DIR/$PHP_LIBDIR, WEB_SO_SHARED_LIBADD)
  dnl   AC_DEFINE(HAVE_WEB_SOLIB,1,[ ])
  dnl ],[
  dnl   AC_MSG_ERROR([wrong web_so lib version or lib not found])
  dnl ],[
  dnl   -L$WEB_SO_DIR/$PHP_LIBDIR -lm
  dnl ])
  dnl
  dnl PHP_SUBST(WEB_SO_SHARED_LIBADD)

  PHP_NEW_EXTENSION(web_so, web_so.c, $ext_shared,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
fi
