format PE

entry main

include "win32ax.inc"

section '.data' data readable writeable
    two dq 2.0 ;делитель
    result dq ? ; результирующая переменная
    one dq 1.0
    print dq ? ; переменная для печати
    output db 256  dup(?) ;контейнер строки вывода


section '.code' code executable

main:
                              

    finit

        
     fld qword[one] ; добавить в стек
     fstp qword [result] ; сохранить head стека в result и убрать
     find_min_loop:
        fld qword [two]
        fld qword [one]
        fld qword [result]
        ; стек имеет вид s0 - result, s1 - one, s2 - two
        fdiv st0, st2 ; делим на 2, по методу дихотомии
        fcomi st1 ; если переменная переполнилась и стала равна 1
        je done             
        ;вывод промежуточного результата
        fst qword [print]
        invoke sprintf, output, ' on iter %.16f',dword[print], dword[print+4]
        invoke MessageBox, 0, output, "Min loop", MB_OK
        fadd st0, st1 ;добавить к вершине стека(левая граница) 1
        fst qword [result] ; поместить вершину стека в result
        jmp find_min_loop ; начать цикл заново
        

    done:
        ; вывести результат
        invoke sprintf, output, ' is %.16f',dword[print], dword[print+4]
        invoke MessageBox, 0, output, "Min loop", MB_OK


    invoke ExitProcess, 0


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
           getch, '_getch',\
           sprintf, 'sprintf'
