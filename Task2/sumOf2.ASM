format PE console

entry _main
include 'win32a.inc'

section '.data' data readable writable

        inputFirstValueString db 'Input first value: ', 0
        inputSecondValueString db 'Input second value: ', 0
        inputOperationTypeString db 'Input operation: ', 0
        plus db '+', 0
        equal db '=', 0
        integerFormat db '%d', 0
        stringFormat db '%d', 0
        formatOut db '%d', 0
        operation: times 4 db 0
        integer1: times 4 db 0
        integer2: times 4 db 0

        NULL = 0

section '.code' code readable executable
        _main:
                push ebx

                push inputFirstValueString
                call [printf]

                push integer1
                push integerFormat
                call [scanf]

                add esp, 8

                push inputSecondValueString
                call [printf]

                add esp, 8
                push integer2
                push integerFormat
                call [scanf]
                add esp, 8

                mov ebx, dword[integer1]

                push ebx
                push formatOut
                call[printf]
                add esp, 4

                push  plus
                call [printf]

                mov ebx, dword[integer2]
                push ebx
                push formatOut
                call[printf]
                push equal
                call [printf]

                add esp, 8

                mov ebx, dword[integer1]
                mov ecx, dword[integer2]
                add ebx, ecx
                push ebx
                push formatOut
                call [printf]
                call [getch]

                push NULL
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