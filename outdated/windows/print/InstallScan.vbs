Dim sobjWshShell : Set sobjWshShell = CreateObject("WScript.Shell")
Dim sobjFso : Set sobjFso = CreateObject ("Scripting.FileSystemObject")
Public macscaner, namescaner

'ipScaner = InputBox (" Введите имя сетевого сканера", "Scaner Install")
ipscaner = Wscript.arguments.Item(0)
url="http://"+ipScaner+"/info_configuration.html?tab=Status&menu=DevConfig"
WindowsPath = sobjWshShell.ExpandEnvironmentStrings("%WinDir%")

Call process_html (url)

Sub process_html (up_http)
  dim xmlhttp : set xmlhttp = createobject ("msxml2.xmlhttp.3.0")
	xmlhttp.open "get", up_http, false
	xmlhttp.send
	
dim response_array : response_array = split (xmlhttp.responseText, "itemFont")

	dim re : Set re = new RegExp
	
	re.Pattern = "..:..:..:..:..:.."
    
	
	dim i
	for i = 0 to ubound(response_array)
	if re.Test(response_array(i)) Then
	
	macScaner = Replace(Mid(response_array(i), 3 , 17), ":", "")
'	WScript.Echo macScaner
	end if
	Next
	
	    response_array = split (xmlhttp.responseText, "title")
		DutyName= response_array(1)
	nameScaner = Mid (DutyName,2 , InStr ( DutyName, "&")-2)
'	WScript.Echo Mid (DutyName,2 , InStr ( DutyName, "&")-2)
	
	set re = nothing
	set xmlhttp = nothing
End Sub

Select Case nameScaner
	Case "HP LaserJet 3052"
		 
		strInstallPath = distribPath & "hppniscan01.exe -f hppasc01.inf" & _
		" -m ""VID_03F0&Pid_3317&IP_SCAN"" -a " & ipScaner &" -e " & macScaner & " -n 1"
		Call Copy
	Case "HP LaserJet 3055"
		
		strInstallPath = distribPath & "hppniscan01.exe -f hppasc01.inf" & _
		" -m ""VID_03F0&Pid_3417&IP_SCAN"" -a " & ipScaner &" -e " & macScaner & " -n 1"
		Call Copy
	Case "HP LaserJet 3390"
		strInstallPath = distribPath & "hppniscan01.exe -f hppasc01.inf" & _
		" -m ""VID_03F0&Pid_3517&IP_SCAN"" -a " & ipScaner &" -e " & macScaner & " -n 1"
		Call Copy
	Case "HP LaserJet M1522n MFP"
	   	strInstallPath = distribPath & "hppniscan01.exe -f hppasc08.inf" & _
		" -m ""VID_03F0&Pid_4517&IP_SCAN"" -a " & ipScaner &" -e " & macScaner & " -n 1"
				
End Select

WScript.StdOut.WriteLine nameScaner
ExecAndGetResult (strInstallPath)


Function ExecAndGetResult (strCommand)
	 'On Error Resume Next
	 'Err.Clear	
	 Dim objExec
   	 Set objExec = sobjWshShell.Exec (strCommand)
	'wscript.echo strCommand
	 ' Wait For Completion
  	  Do While objExec.Status = 0
     	   WScript.Sleep 1
  	  Loop
	  ExecAndGetResult = objExec.ExitCode
	  
End Function

Sub Copy ()
sobjFso.CopyFile "hpzi*12.dll",  WindowsPath & "\system32"
End Sub

WScript.StdOut.writeline "Сканер установлен."
'WScript.Echo "Сканер установлен."
