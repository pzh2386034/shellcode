#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <utility.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>

static link head = NULL;
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

link make_node(m_temp item)
{
  link p = malloc(sizeof(*p));
  p->item = item;
  p->next = NULL;
  return p;
}
void free_node(link p)
{
  free(p);
}
link search(m_temp key)
{
  link p;
  for (p = head; p; p->next) {
    if (p->item == key)
      {
        return p;
      }
  }
  return NULL;
}
void insert(link p)
{
  p->next = head;
  head = p;
}
void del(link p)
{
  link pre;
  if (p == head) {
    head = p->next;
    free_node (p);
  }
  for (pre =head; pre;pre = pre->next) {
    if(pre->next == p)
      {
        pre->next = p->next;
        free_node(p);
        return;
      }
  }
}
void traverse(void (*visit)(link))
{
  link p;
  for (p = head; p; p->next) {
    visit(p);
  }
}
void destory(void)
{
  link q;
  link p =head;
  head=NULL;
  while (p)
    {
      q=p;
      p = p->next;
      free_node(p);
    }
}
void push(link p)
{
  insert(p);
}
link pop(void)
{
  if (head == NULL) {
    return NULL;
  }
  else
    {
      link p = head;
      head = head->next;
      return p;
    }
}
