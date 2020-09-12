format PE console

entry _main
include 'win32a.inc'

section '.data' data readable writable

        helloStr db 'This is my first program!', 0
        firstInteger db "%d", 0

        NULL = 0

section '.code' code readable executable
        _main:
                push helloStr

                call [printf]

                push firstInteger
                call [scanf]
                push firstInteger
                call[printf]
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