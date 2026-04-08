#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

typedef int (*op)(int,int);

int main(){
    char opstr[8]; int a, b;
    while (1) {
        scanf("%s%d%d", opstr, &a, &b);
        char lib[16];
        snprintf(lib, sizeof(lib), "./lib%s.so", opstr);
        void* handle = dlopen(lib, RTLD_LAZY);
        if (!handle) continue;
        dlerror();
        op oper = (op)dlsym(handle, opstr);
        char* error = dlerror();
        if (error) continue;
        printf("%d\n", oper(a,b));
        dlclose(handle);
    } 
}