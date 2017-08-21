#include <stdio.h>

extern int puts(const char *str);

int main(void)
{
    puts("Result is:");
    puts(itoa(7));
    puts("\n");

}
