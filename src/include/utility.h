#ifndef UTILITY_H_
#define UTILITY_H_
#define ERROR        1
#define OK           0
#define READANDWRITE 600

#ifdef __cplusplus
extern "C" {
#endif
int create_temp_file(const char* filename, char* tmp, size_t len);

#ifdef __cplusplus
}
#endif

#endif
