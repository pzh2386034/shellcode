#ifndef UTILITY_H_
#define UTILITY_H_
#define ERROR 1
#define OK 0
#define READANDWRITE 600

#define MSG_TRY "try again\n"

#define ACTUAL_FILE_PATH "/tmp/actual"
#define VIRTUA_FILE_PATH "/tmp/virtual"
typedef char m_temp;
typedef struct node *m_link;
struct node
{
    m_temp item;
    m_link next;
};
#ifdef __cplusplus
extern "C" {
#endif
int create_temp_file(const char *filename, char *tmp, size_t len);
int read_tty(void);
// 单项链表实现

m_link make_node(m_temp item);
void free_node(m_link p);
m_link search(m_temp key);
void insert(m_link p);
void del(m_link p);
void traverse(void (*visit)(m_link));
void destory(void);
void push(m_link p);
m_link m_pop(void);
// task
// 1. insert函数实现插入排序
// 2/ 实现队列的enqueue和dequeue操作。在链表得到末尾再维护一个指针tail,
// 在tail处enqueue，在head处dequeue
// 3. 实现函数void reverse(void), 将链表反转
// emd
  void dirwalk(char *dir, void (*fcn)(char *));
  void fsize(char *name);
  void child_process(void);
  void child_pip(void);
  void child_test_pip(void);
#ifdef __cplusplus
}
#endif

#endif
