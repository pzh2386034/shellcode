#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <utility.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>

#include <sys/wait.h>
#include <fcntl.h>
#include <dirent.h>

#define MAX_LINE 89
static m_link head = NULL;
int create_temp_file(const char * filename, char * tmp, size_t len)
{
  int tmpfile ;
  char * delim = "/";
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

m_link make_node(m_temp item)
{
  m_link p = malloc(sizeof(*p));
  p->item = item;
  p->next = NULL;
  return p;
}
void free_node(m_link p)
{
  free(p);
}
m_link search(m_temp key)
{
  m_link p;
  for (p = head; p; p->next) {
    if (p->item == key)
      {
        return p;
      }
  }
  return NULL;
}
void insert(m_link p)
{
  p->next = head;
  head = p;
}
void del(m_link p)
{
  m_link pre;
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
void traverse(void (*visit)(m_link))
{
  m_link p;
  for (p = head; p; p->next) {
    visit(p);
  }
}
void destory(void)
{
  m_link q;
  m_link p =head;
  head=NULL;
  while (p)
    {
      q=p;
      p = p->next;
      free_node(p);
    }
}
void push(m_link p)
{
  insert(p);
}
m_link m_pop(void)
{
  if (head == NULL) {
    return NULL;
  }
  else
    {
      m_link p = head;
      head = head->next;
      return p;
    }
}
//非阻塞读终端
int read_tty(void)
{
  char buf[10];
  int fd, n;
  fd = open("/dev/tty", O_RDONLY|O_NONBLOCK);
  if(fd < 0)
    {
      perror("open /dev/tty");
      exit(1);
    }

 tryagain:
  n = read(fd, buf, 10);
  if (n < 0)
    {
      if (errno == EAGAIN)
        {
          sleep(1);
          write(STDOUT_FILENO, MSG_TRY, strlen(MSG_TRY));
          goto tryagain;
        }
      perror("read /dev/tty");
      exit(1);
    }
  write(STDOUT_FILENO, buf, n);
  close(fd);
  return 0;
}

//递归一个目录下的所有子目录
#define MAX_PATH 1024
void dirwalk(char *dir, void (*fcn) (char *))
{
  char name[MAX_PATH];
  struct dirent *dp;
  DIR *dfd;
  if ((dfd = opendir(dir)) == NULL)
    {
      printf("dirwalk: can not open dir(%s), errno(%d)", dir, errno);
      return;
    }
  while((dp = readdir(dfd)) != NULL)
    {
      if (strcmp(dp->d_name, ".") ==0
          || strcmp(dp->d_name, "..") == 0)
        continue;
      if (strlen(dir) + strlen(dp->d_name) + 2 > sizeof(name))
        printf("dirwalk:name(%s, %s) too long", dir, dp->d_name);
      else {
        printf("deal %s/%s", dir, dp->d_name);
        sprintf(name, "%s/%s", dir, dp->d_name);
        (*fcn) (name);
      }
    }
  closedir(dfd);
}
void fsize(char *name)
{
  struct stat stbuf;
  if (stat(name, &stbuf) == -1)
    {
      printf("fsize: can not access %s\n", name);
      return;
    }
  if ((stbuf.st_mode & S_IFMT) == S_IFDIR)
    {
      dirwalk(name, fsize);
    }
  printf("%8ld %s\n", stbuf.st_size, name);
}
//子进程函数
void child_process(void)
{
  pid_t pid;
  pid = fork();
  if( 0> pid)
    {
      printf("fork error\n");
      exit(1);
    } /* fork 失败 */
  if ( 0 == pid)
    {
      int i = 0;
      for(i = 3; i > 0; i ++ )
        {
          printf("I am in child\n");
          sleep(1);
        }
      exit(3);
    }
  else
    {
      int stat_val;
      /* 作业：可以在头文件中查以下宏做了什么运算 */
      waitpid(pid, &stat_val, 0);
      /* 如果进程正常终止，wifexited取出的字段值非零 */
      if (WIFEXITED(stat_val))
        printf("child exited with code %d.\n", WEXITSTATUS(stat_val));
      /* 如果子进程是收到信号而异常终止，wifsignaled取出的字段非零，WTERMSIG取出的字段值就是信号的编号 */
      else if(WIFSIGNALED(stat_val))
        printf("child terminal abnormal, sigmal %d\n", WTERMSIG(stat_val));
    }
  return ;
}

void child_pip(void)
{
  /* 父进程创建管道，写数据f[1], 子进程读数据 */
  pid_t pid = 0;
  int fd[2];
  if (0 > pipe(fd))
    {
      printf("pipe create err\n");
      exit(1);
    }
  pid = fork();
  if (0 > pid)
    {
      printf("fork error\n");
    }
  if (pid == 0)
    {
      /* 子进程 */
      close(fd[1]);
      int n = 0;
      char line[MAX_LINE] = {0};
      n = read(fd[0], line, MAX_LINE);
      if (n <= 0)
        {
          printf("READ PIPE ERR\n");
        }
      else
        {
          printf("read %d chars, %s\n", n, line);
          write(STDOUT_FILENO, line, n);
        }
    }
  else
    {
      /* 父进程 , 关闭读端*/
      close(fd[0]);
      int n = 0;
      n = write(fd[1], "panzehua is big bosh", 20);
      if (n <= 0)
        {
          printf("WRITE PIPE ERR\n");
        }
    }
  return ;
}
void child_test_pip(void)
{
  int fd[2];
  char line[MAX_LINE];
  int n =0;
  if (0 > pipe(fd))
    {
      printf("create pipe err\n");
      return;
    }
  n = write(fd[1], "panzehua~~", MAX_LINE);
  if ( 0 > n)
    {
      printf("read pipe fail, n <=0\n");
    }
  n = read(fd[0], line, MAX_LINE);
  if ( 0 > n)
    {
      printf("read pipe fail, n <=0\n");
    }
  else
    {
      printf("%s(%d)", line, n);
    }
  return;
}
