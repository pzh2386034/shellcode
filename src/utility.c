#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <utility.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>

int create_temp_file(const char * filename, char * tmp, size_t len)
{
  int tmpfile ;
  mode_t prevmask;
  if (!filename || !tmp)
  {
      printf("null point.\n");
      return ERROR;
  }
  if (len <= strlen(filename))
  {
      printf("filename(%s) is too long.\n", filename);
      return ERROR;
  }
  sprintf(tmp, "%sXXXXXX", filename);
  tmpfile = mkstemp(tmp);
  if (!tmpfile)
  {
      printf("create tmp file name failed, errcode(%d)", errno);
      return ERROR;
  }
  prevmask = umask(0600);
  int fd = mkstemp(tmp);
  if (!fd)
  {
      printf("create tmp file failed, errcode(%d)", errno);
  }
  (void)umask(prevmask);
  return OK;
}
