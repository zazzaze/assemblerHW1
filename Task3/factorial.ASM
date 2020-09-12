format PE console

entry _main
include 'win32a.inc'

section '.data' data readable writable
        questionString db 'Computed factorial:' , 0
        resultString db 'Result:', 0
        outputString db "%d", 10, 0
        integerFormat db '%d', 0
        N: times 4 db 0

section '.code' code readable executable
        _main:
                push questionString
                call [printf]
                add esp, 8

                push N
                push integerFormat
                call [scanf]
                add esp, 4

                mov ecx, dword[N]
                mov eax, ecx
                CYCLE:
                   cmp ecx, 1
                   jle EXIT
        
                   sub ecx, 1
                   mul ecx
                   jmp CYCLE
                EXIT:
                push eax
                push outputString
                call [printf]
                call [getch]
                call [ExitProcess]


section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'