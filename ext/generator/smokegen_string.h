// smokegen uses this file instead of /usr/include/string.h because
// it chokes on some of gcc's language additions.

#ifndef _STRING_H
#define _STRING_H 1

#include <stddef.h>

void    *memccpy(void *, const void *, int, size_t);

void    *memchr(const void *, int, size_t);
int      memcmp(const void *, const void *, size_t);
void    *memcpy(void *, const void *, size_t);
void    *memmove(void *, const void *, size_t);
void    *memset(void *, int, size_t);
char    *strcat(char *, const char *);
char    *strchr(const char *, int);
int      strcmp(const char *, const char *);
int      strcoll(const char *, const char *);
char    *strcpy(char *, const char *);
size_t   strcspn(const char *, const char *);

char    *strdup(const char *);

char    *strerror(int);

int     *strerror_r(int, char *, size_t);

size_t   strlen(const char *);
char    *strncat(char *, const char *, size_t);
int      strncmp(const char *, const char *, size_t);
char    *strncpy(char *, const char *, size_t);
char    *strpbrk(const char *, const char *);
char    *strrchr(const char *, int);
size_t   strspn(const char *, const char *);
char    *strstr(const char *, const char *);
char    *strtok(char *, const char *);

char    *strtok_r(char *, const char *, char **);

size_t   strxfrm(char *, const char *, size_t);

#endif  // _STRING_H
