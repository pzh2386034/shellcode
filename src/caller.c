#include <stdlib.h>
#include <stdio.h>
#include "string.h"
extern int end, etext, edata;
extern int _etext, _edata, _end;
int main()
{
  printf("&etext=%p, &edata=%p, &end=%p\n", &etext, &edata, &end);
  printf("&etext=%p, &edata=%p, &end=%p\n", &_etext, &_edata, &_end);
    return 0;
}
