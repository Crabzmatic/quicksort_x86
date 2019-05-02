.global quickSort
.data
.bss
.text
quickSort:
    # void quickSort(int* integers, int n);

    #   STACK AT START
    #   ________________
    #  |        n       |
    #  | integers (ptr) |
    #  | return address | <-- esp
    #                     

    # after function termination registers
    #        edi, esi, ebp, ebx
    # must be the same as they were at start

    # to do this, we will push them to the stack
    push %ebp

    # remember current end of stack in ebp
    mov %esp, %ebp

    push %ebx
    push %esi
    push %edi

    #   STACK AT START
    #   _______________
    #  | array length  |
    #  | array pointer |
    #  | return adress | 
    #  | old ebp       | <-- ebp
    #  | old ebx       |
    #  | old esi       |
    #  | old edi       | <-- esp

    # ebp + 8    is integers
    # ebp + 12   is n

    mov 8(%ebp), %esi
    # esi is now pointing to array 'integers'

    # set eax to n
    mov 12(%ebp), %eax

    # set ecx to 4 (int size)
    mov $4, %ecx

    # multiply ecx and eax to get end offset
    mul %ecx

    # set the end offset to ecx
    mov %eax, %ecx

    # eax will be used for low index
    # we xor it, so it is 0
    xor %eax, %eax

    # ebx will be used for high index
    # end offset is currently stored in ecx
    mov %ecx, %ebx

    call quickSortRecursive

    # restore the old registers
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret

quickSortRecursive:

    # check if low index is greater than or equal to high index
    cmp %ebx, %eax
    jge end

    # we will save low index and high index on stack
    push %eax
    push %ebx

    # increment high index, so it points right after array's end
    add $4, %ebx

    # pivot will be stored in edi
    # pivot will be first element in sub-array
    #edi <-- integers[low index]
    mov (%esi,%eax), %edi

    loop:
        # find element greater than pivot
        lowIndex:
            # increment low index
            add $4, %eax

            # check if low index is greater than or equal to high index
            # (if low index is out of the current sub-array)
            # break
            cmp %ebx, %eax
            jge endLowIndex

            # check if integers[low index] >= pivot
            # break
            cmp %edi, (%esi,%eax)
            jge endLowIndex

            # return to start of this loop
            jmp lowIndex
        endLowIndex:

        # find element smaller than pivot
        highIndex:
            # decrement high index
            sub $4, %ebx

            # check if integers[high index] <= pivot
            # break
            cmp %edi, (%esi,%ebx)
            jle endHighIndex

            # return to start of this loop
            jmp highIndex
        endHighIndex:

        # check if low index is greater or equal to high index
        # break
        cmp %ebx, %eax
        jge endLoop

        # now push integers[low index] and
        # integers[high index] to stack
        push (%esi,%eax)
        push (%esi,%ebx)

        #          STACK
        #           ...
        # | integers[low index]  |
        # | integers[high index] |
        #

        # now pop them back in reverse order to swap
        pop (%esi,%eax)
        pop (%esi,%ebx)

        # return to loop start
        jmp loop
    endLoop:

    # restore high index to edi
    pop %edi

    # restore low index to ecx
    pop %ecx

    # swap pivot between two sub-arrays
    swap:
        # check if low index == pivot index
        # no swapping (same element)
        cmp %ecx, %ebx
        je endSwap

        # swap array[low index] with array[pivot index]
        push (%esi,%ecx)
        push (%esi,%ebx)

        pop (%esi,%ecx)
        pop (%esi,%ebx)
    endSwap:

    # set eax back to low index
    mov %ecx, %eax

    # save high index
    push %edi
    # save the pivot index
    push %ebx

    # decrement ebx
    sub $4, %ebx

    # quickSort(integers, low index, pivot index - 1)
    call quickSortRecursive

    # restore pivot index to eax
    pop %eax

    # increment eax
    add $4, %eax

    # restore high index to ebx
    pop %ebx

    # quickSort(integers, pivot index + 1, high index)
    call quickSortRecursive

    end:
        ret
