.global quickSort
.data
.bss
.text
quickSort:
    #void quickSort(int* integers, int n);

    #   STACK AT START
    #   ________________
    #  |        n       |
    #  | integers (ptr) |
    #  | return address |  <-- esp
    #

    #After function termination registers
    #        edi, esi, ebp, ebx, edx
    #must be the same as they were at start

    #To do this, we will push them to the stack
    push %ebp

    #remember current end of stack in ebp
    mov %esp, %ebp

    push %ebx
    push %esi
    push %edi
    push %edx

    #        STACK
    #   _______________
    #  | array length  |
    #  | array pointer |
    #  | return adress |
    #  | old ebp       | <-- ebp
    #  | old ebx       |
    #  | old esi       |
    #  | old edi       |
    #  | old edx       | <-- esp

    #ebp + 8    is integers
    #ebp + 12   is n

    mov 8(%ebp), %esi
    #esi is now pointing to array 'integers'

    #set eax to n
    mov 12(%ebp), %eax

    #multiply eax with 4 (2^2) (int size) to get end offset
    sal $2, %eax

    #set the end offset to ecx
    mov %eax, %ecx

    #ecx is pointing after the array's end
    #so we subtract 4, to point at the last element
    sub $4, %ecx

    #eax will be used for low index
    #we xor it, so it is 0
    xor %eax, %eax

    #ebx will be used for high index
    #end offset is currently stored in ecx
    mov %ecx, %ebx

    call quickSortRecursive

    #restore the old registers
    pop %edx
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret

quickSortRecursive:

    #if low index is greater than or equal to high index
    cmp %ebx, %eax
    jge end

    #save high and low index
    push %ebx
    push %eax

    #pivot will be stored in edi
    #pivot will be last element in array
    #edi <-- integers[high index]
    mov (%esi,%ebx), %edi

    #ecx = i = (low - 1)
    mov %eax, %ecx
    sub $4, %ecx

    #eax = j = low

   loop:

     #j < high
     cmp %ebx, %eax
     jge endLoop

     #jump to loop start if integers[j] > pivot
     cmp %edi, (%esi, %eax)
     jg incrj

     add $4, %ecx

     #swap integers[i], integers[j]
     mov (%esi, %eax), %edx
     xchg %edx, (%esi, %ecx)
     mov %edx, (%esi, %eax)

   incrj:
     #j++
     add $4, %eax
   jmp loop

   endLoop:

    #ecx = i + 1
    add $4, %ecx

    #swap integers[i + 1], integers[high]
    mov (%esi, %ecx), %edx
    xchg %edx, (%esi, %ebx)
    mov %edx, (%esi, %ecx)

    #ecx = i
    sub $4, %ecx

    #eax = low
    pop %eax
    mov %ecx, %ebx

    push %ecx

    #quickSort(integers, low index, i)
    call quickSortRecursive

    pop %ecx

    #from i to i+2; pivot was i + 1
    add $8, %ecx

    mov %ecx, %eax
    #ebx = high

    pop %ebx

    #quickSort(integers, i+2, high index)
    call quickSortRecursive

    end:
        ret
