
; example of simplified Windows programming using complex macro features

include 'win32ax.inc' ; you can simply switch between win32ax, win32wx, win64ax and win64wx here

.code

  start:

        invoke  MessageBox,HWND_DESKTOP,"Hello, are you okay today?",invoke GetCommandLine,MB_YESNO

        .if eax = IDYES
                invoke  MessageBox,HWND_DESKTOP,"That's fine!!!","New message!",MB_OK
        .elseif eax = IDNO
                  invoke  MessageBox,HWND_DESKTOP,"Bad news(((","New message!",MB_OK
        .endif

        invoke  ExitProcess,0

.end start
