; Anikeev Egor, BPI194, variant - 3
; Massiv B iz summ sosednix elementov A ({A[0] + A[1], A[1]+A[2], ...})
format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'Input size of vector greater than 1 and less than 100: ', 0
        strVecElemI  db 'A[%d] =  ', 0
        strScanInt   db '%d', 0
        strArrElemOut  db '%d ',0 , 0
        strArrA        db 'Array A:', 10, 0
        newLine        db '',10,0
        strArrB        db 'Array B:', 10, 0
        vec_size     dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100
        vecB         rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        call VectorInput
        call getSumOfVector
        push strArrA
        call [printf]
        call ArrAOut
        push newLine
        call [printf]
        push strArrB
        call [printf]
        call ArrBOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        cmp [vec_size], 1
        jle VectorInput
        cmp [vec_size], 100
        jge VectorInput
getVector:
        xor ecx, ecx
        mov ebx, vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector

        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
ArrAOut:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vec
        inc [vec_size]
        jmp putVecLoop
ArrBOut:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vecB
        dec [vec_size]
        jmp putVecLoop
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector
        mov [i], ecx

        push dword [ebx]
        push strArrElemOut
        call [printf]
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------
getSumOfVector:
        xor ecx, ecx
        mov ebx, vecB
        mov edx, vec
        dec [vec_size]
sumLoop:
        cmp ecx, [vec_size]
        jge endOfSumLoop
        mov eax, 0
        add eax, [edx]
        add edx, 4
        add eax, [edx]
        mov [ebx], eax
        add ebx, 4
        inc ecx
        jmp sumLoop

endOfSumLoop:
        ret
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'