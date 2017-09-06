#ifndef UTILITY_H_
#define UTILITY_H_
#define ERROR        1
#define OK           0
#define READANDWRITE 600

#ifdef __cplusplus
extern "C" {
#endif
int create_temp_file(const char* filename, char* tmp, size_t len);
  // 单项链表实现
typedef char m_temp;
typedef struct node* link;
struct node
{
    m_temp item;
    link next;
};

link make_node(m_temp item);
void free_node(link p);
link search(m_temp key);
void insert(link p);
void del(link p);
void traverse(void (*visit)(link));
void destory(void);
void push(link p);
void pop(void);
  // task
  // 1. insert函数实现插入排序
  // 2/ 实现队列的enqueue和dequeue操作。在链表得到末尾再维护一个指针tail, 在tail处enqueue，在head处dequeue
  // 3. 实现函数void reverse(void), 将链表反转
  // emd
#ifdef __cplusplus
}
#endif

#endif
