/*
Original code by Haali      - http://haali.su/winutils/
Small changes by Rumpel     - http://rumpel.k66.ru/lswitch.html
*/

#define _WIN32_WINNT 0x500

#include <windows.h>
#include <tchar.h>

TCHAR	g_prog_dir[MAX_PATH*2];
DWORD	g_prog_dir_len;
HHOOK	g_khook;
HANDLE  g_hEvent;
UINT	g_key = VK_LWIN;    //default key: 
                            //91 (0x5B) - VK_LWIN (Left Windows)
                            //20 (0x14) - VK_CAPITAL (Caps Lock)
                            //93 (0x5D) - VK_APPS (Application key)

LRESULT CALLBACK KbdHook(int nCode, WPARAM wParam, LPARAM lParam) {
    if(nCode < 0)
        return CallNextHookEx(g_khook, nCode, wParam, lParam);
    if(nCode == HC_ACTION) {
        KBDLLHOOKSTRUCT   *ks=(KBDLLHOOKSTRUCT*)lParam;
        if(ks -> vkCode == g_key) {
            if(wParam == WM_KEYDOWN) {
	            HWND hWnd = GetForegroundWindow();

	            //small bugfix
	            HWND hWnd_thread = 0;
	            AttachThreadInput(GetCurrentThreadId(), GetWindowThreadProcessId(hWnd, NULL), TRUE);
	            hWnd_thread = GetFocus();
	            if (hWnd_thread)
                    hWnd = hWnd_thread;
	            //----------------

	            if (hWnd)
	                PostMessage(hWnd, WM_INPUTLANGCHANGEREQUEST, 0, (LPARAM)HKL_NEXT);
            }
            return 1;
        }
    }
skip:
    return CallNextHookEx(g_khook, nCode, wParam, lParam);
}

void  failedx(const TCHAR *msg) {
    MessageBox(NULL, msg, _T("Error"), MB_OK|MB_ICONERROR);
    ExitProcess(1);
}

void  failed(const TCHAR *msg) {
    DWORD       fm;
    TCHAR       *msg1, *msg2;
    const TCHAR *args[2];
  
    fm = FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
                       NULL, GetLastError(), 0, (LPTSTR)&msg1, 0, NULL);
    if(fm == 0)
        ExitProcess(1);
    args[0] = msg;
    args[1] = msg1;
    fm = FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_STRING|FORMAT_MESSAGE_ARGUMENT_ARRAY,
                       _T("%1: %2"), 0, 0, (LPTSTR)&msg2, 0, (va_list*)&args[0]);
    if(fm == 0)
        ExitProcess(1);
    MessageBox(NULL, msg2, _T("Error"), MB_OK|MB_ICONERROR);
    ExitProcess(1);
}

void CALLBACK TimerCb(HWND hWnd,UINT uMsg,UINT_PTR idEvent,DWORD dwTime) {
    if (WaitForSingleObject(g_hEvent, 0) == WAIT_OBJECT_0)
        PostQuitMessage(0);
}

void xMain() {
    MSG     msg;
    DWORD	sz;
    BOOL	fQuit = FALSE;
    LPWSTR  *argv;
    int     argc = 0;
    int     cmdKey = 0;

    argv = CommandLineToArgvW(GetCommandLineW(), &argc);        //parsing command line
    if(argv != NULL && argc >=2) {                              //validating command line
        cmdKey = _wtoi(argv[1]);
        if(cmdKey >= 0x01 && cmdKey <=0xFE)                         //validating provided cmd key
            g_key = cmdKey;
    }
    LocalFree(argv);                                            //freeing memory from cmd params
  
    g_hEvent=CreateEvent(NULL, TRUE, FALSE, _T("HaaliLSwitch"));
    if(g_hEvent == NULL)
        failed(_T("CreateEvent()"));
    if(GetLastError() == ERROR_ALREADY_EXISTS) {
        if(fQuit) {
            SetEvent(g_hEvent);
            goto quit;
        }
        failedx(_T("LSwitch is already running!"));
    }

    if(fQuit)
        failedx(_T("LSwitch is not running!"));

    sz = GetModuleFileName(NULL,g_prog_dir,MAX_PATH);
    if(sz == 0)
        failed(_T("GetModuleFileName()"));
    if(sz == MAX_PATH)
        failedx(_T("Module file name is too long."));
    while(sz > 0 && g_prog_dir[sz-1] != _T('\\'))
        --sz;
    g_prog_dir_len = sz;
  
    if(SetTimer(NULL,0,500,TimerCb) == 0)
        failed(_T("SetTimer()"));

    g_khook = SetWindowsHookEx(WH_KEYBOARD_LL,KbdHook,GetModuleHandle(0),0);
    if(g_khook == 0)
        failed(_T("SetWindowsHookEx()"));

    while(GetMessage(&msg, 0, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
  
    UnhookWindowsHookEx(g_khook);
quit:
    CloseHandle(g_hEvent);

    ExitProcess(0);
}
