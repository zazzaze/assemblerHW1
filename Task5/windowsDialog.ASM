format PE GUI 4.0 ;fasm x32 tutorial - http://mykeylogger.biz
entry start
 
include 'win32a.inc'
 
section '.data' data readable writeable ;fasm tutorial
     wHMain         dd   ?
     wHInstance     dd   ?
 
     wTitle         db   'TextBox',0 ;name of our window
     wClsName       db   'TUT09',0      ;name of our window class
 
     wMsg      MSG
     wCls      WNDCLASS ;fasm x32 tutorial
 
     ;controller
     btnClsName     db   'button',0 ;fasm tutorial
     btnTxt         db   'My First Button',0
     editClsName    db   'edit',0
     editTxt        db   "Wow! i'm inside an edit box now",0 ;fasm x32 tutorial
     editBuffer:    times 513 db 0
 
     btnHandle      dd   ?
     editHandle     dd   ?
     ;controller constant
     btnId     equ  100
     editId    equ  200
 
section '.code' code readable executable ;fasm x32 tutorial
     start:
          ; +------------------------------+
          ; | registering the window class |
          ; +------------------------------+
          invoke    GetModuleHandle,NULL
                    mov  [wHInstance],eax
                    mov  [wCls.hInstance],eax
                    mov  [wCls.style],CS_HREDRAW or CS_VREDRAW
                    mov  [wCls.lpfnWndProc],window_procedure ;fasm x32 tutorial
                    mov  [wCls.lpszClassName],wClsName
                    mov  [wCls.lpszMenuName],30   ;our menu id
                    mov  [wCls.hbrBackground],COLOR_WINDOW+1
          invoke    LoadIcon,NULL,IDI_APPLICATION
                    mov  [wCls.hIcon],eax
          invoke    LoadCursor,NULL,IDC_ARROW
                    mov  [wCls.hCursor],eax
          invoke    RegisterClass,wCls
 
          ; +--------------------------+
          ; | creating the main window |
          ; +--------------------------+
          invoke    CreateWindowEx,\ ;fasm x32 tutorial
                         0,\
                         wClsName,\
                         wTitle,\
                         WS_OVERLAPPEDWINDOW,\
                         CW_USEDEFAULT,\
                         CW_USEDEFAULT,\
                         300,\
                         200,\
                         NULL,\
                         NULL,\
                         [wHInstance],\
                         NULL
                    mov  [wHMain],eax ;fasm x32 tutorial
          invoke    ShowWindow,[wHMain],SW_SHOW
          ; +---------------------------+
          ; | entering the message loop |
          ; +---------------------------+
          window_message_loop_start:
               invoke    GetMessage,wMsg,NULL,0,0 ;fasm tutorial
                         or   eax,eax
                         je   window_message_loop_end ;fasm x32 tutorial
               invoke    TranslateMessage,wMsg
               invoke    DispatchMessage,wMsg
                         jmp  window_message_loop_start ;fasm x32 tutorial
 
          window_message_loop_end: ;fasm x32 tutorial
               invoke    ExitProcess,0
 
          ; +----------------------+
          ; | the window procedure |
          ; +----------------------+
          proc window_procedure,hWnd,uMsg,wParam,lParam ;fasm x32 tutorial
               push ebx esi edi    ;eventhough the API would preserved, but play safe :p
               cmp  [uMsg],WM_COMMAND ;fasm x32 tutorial
               je   wmCOMMAND
               cmp  [uMsg],WM_CREATE
               je   wmCREATE
               cmp  [uMsg],WM_DESTROY
               je   wmDESTROY
 
               wmDEFAULT:
                    invoke    DefWindowProc,[hWnd],[uMsg],[wParam],[lParam] ;fasm x32 tutorial
                              jmp  wmBYE
               wmCREATE:
                    invoke    CreateWindowEx,\
                                   WS_EX_CLIENTEDGE,\
                                   editClsName,\
                                   NULL,\
                                   WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_AUTOHSCROLL,\
                                   50,35,200,25,[hWnd],editId,[wHInstance],NULL
                              mov  [editHandle],eax
                    invoke    SetFocus,eax ;fasm x32 tutorial
                    invoke    CreateWindowEx,\
                                   NULL,\
                                   btnClsName,\
                                   btnTxt,\
                                   WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                                   75,70,140,25,[hWnd],btnId,[wHInstance],NULL
                              mov  [btnHandle],eax
                              jmp  wmBYE
               wmCOMMAND:
                              mov  eax,[wParam] ;fasm x32 tutorial
                              cmp  [lParam],0
                              je   wmCOMMAND_menu
                              cmp  ax,btnId  ;check whether is button id
                              je   wmCOMMAND_button
                              jmp  wmBYE
 
                    wmCOMMAND_menu:
                                   cmp  ax,11     ;write something to textbox
                                   je   menu_writesomething
                                   cmp  ax,12     ;clear our textbox
                                   je   menu_cleartext
                                   cmp  ax,13     ;messagebox our text
                                   je   menu_messagebox
                                   jmp  wmBYE
                              menu_writesomething:
                                   invoke    SetWindowText,[editHandle],editTxt ;fasm x32 tutorial
                                             jmp  wmBYE
                              menu_cleartext:
                                   invoke    SetWindowText,[editHandle],NULL
                                             jmp  wmBYE
                              menu_messagebox:
                                   invoke    GetWindowText,[editHandle],editBuffer,512 ;fasm x32 tutorial
                                   invoke    MessageBox,NULL,editBuffer,wTitle,MB_OK
                                             jmp  wmBYE
                    wmCOMMAND_button:
                                   shr  ax,16
                                   cmp  ax,0  ;BN_CLICKED = 0
                                   je   button_clicked
                                   jmp  wmBYE
                              button_clicked:
                                   invoke    SendMessage,[hWnd],WM_COMMAND,13,0
                                             jmp  wmBYE
 
               wmDESTROY:
                    invoke    PostQuitMessage,0 ;fasm x32 tutorial
 
               wmBYE:
                    pop  edi esi ebx
                    ret
          endp
 
section '.idata' import data readable writeable ;fasm x32 tutorial
     library   KERNEL32, 'KERNEL32.DLL',\
               USER32,   'USER32.DLL'
 
     import    KERNEL32,\
               GetModuleHandle,    'GetModuleHandleA',\
               ExitProcess,        'ExitProcess'
 
     import    USER32,\
               RegisterClass,      'RegisterClassA',\
               CreateWindowEx,     'CreateWindowExA',\
               DefWindowProc,      'DefWindowProcA',\
               ShowWindow,         'ShowWindow',\
               LoadCursor,         'LoadCursorA',\
               LoadIcon,           'LoadIconA',\
               SetFocus,           'SetFocus',\
               SetWindowText,      'SetWindowTextA',\
               GetWindowText,      'GetWindowTextA',\
               GetMessage,         'GetMessageA',\
               SendMessage,        'SendMessageA',\
               MessageBox,         'MessageBoxA',\
               TranslateMessage,   'TranslateMessage',\
               DispatchMessage,    'DispatchMessageA',\
               PostQuitMessage,    'PostQuitMessage'
 
section '.rsrc' resource data readable ;fasm x32 tutorial - http://mykeylogger.biz
     directory RT_MENU,appMenu
 
     resource  appMenu,\
               30,LANG_NEUTRAL,menuMain
 
     menu menuMain
          menuitem  '&PopUp',10,MFR_POPUP or MFR_END
          menuitem       '&Write Something to Textbox',11,MFT_STRING
          menuitem       '&Clear Textbox',12,MFT_STRING
                         menuseparator
          menuitem       '&MessageBox my text',13,MFR_END