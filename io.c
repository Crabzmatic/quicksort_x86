#include <stdio.h>
#include <malloc.h>
void quickSort(int* integers, int n);

#define ERROR 1
#define OK 0

int main(){
    int n;
    printf("Enter array length: ");
    int n_res = scanf("%d", &n);
    if (n_res < 1) {
        printf("Error reading array length.\n");
        return ERROR;
    }
    int* integers = (int*) malloc(n * sizeof(int));
    if (integers == NULL){
    	printf("Array allocation failed.\n");
	return ERROR;
    }
    for (int i = 0; i < n; ++i) {
        int int_res = scanf("%d", &integers[i]);
        if (int_res < 1) {
            printf("Error reading input numbers.\n");
            return ERROR;
        }
    }
    quickSort(integers, n);
    printf("\n");
    printf("Sorted array:\n");
    for (int i = 0; i < n; ++i) {
        int print_res = printf("%d\n", integers[i]);
        if (print_res < 0){
            printf("Error printing output.\n");
            return ERROR;
        }
    }
    free(integers);
    return OK;
}
