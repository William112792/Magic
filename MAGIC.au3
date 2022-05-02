#Region ### Included Scripts ###
#include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <Inet.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <WinApi.au3>
#include <GuiScrollBars.au3>
#EndRegion ### Finished Inclusions ###
#Region GUI Prep
Local $sShortName = "MAGIC"

Local $sShortName = "MAGIC"
Local $sLongName = "My Autonomous Group of Integrated Commands"
Local $sShortOwner = "William M Gordon"

Local $sOwner = $sShortOwner

Local $sTitle = $sShortName & " || " & $sLongName
Local $WinFont = "Tahoma"
Local $dColor = "0x000000"

Opt("WinTitleMatchMode", 4)
$get=ControlGetPos("classname=Shell_TrayWnd", "", "ReBarWindow321")
$Height_Minus_Taskbar=@DesktopHeight-$get[3]

Global $MRI_GUI = GUICreate($sShortName & " - Status", 400, $Height_Minus_Taskbar, @DesktopWidth - 400, 0, $WS_POPUP)
GUICtrlSetFont(-1, 8.5, 400, 0, $WinFont)
GUISetBkColor($dColor)
#EndRegion GUI Prep - Ending

$g_idMemo = GUICtrlCreateEdit("", 5, 15, 385, $Height_Minus_Taskbar - 60, $WS_VSCROLL)
GUISetState(@SW_SHOW, $MRI_GUI)

#Region CHKDSK Analysis
$i = 20
ProgressOn("Administrator: MAGIC Analyzer", "Running Analysis (CHKDSK)" & @CRLF & "..." , "0%", -1, -1, $WS_POPUP)
$sCHKDSK = @WindowsDir & "\Temp\" & @MDAY & @MON & @YEAR & @MIN & @SEC & "chkdsk.txt"
ProgressSet(20, 20 & "%")
$pWinCHKDSK = ShellExecute(@ComSpec, "/c title CHKDSK is Running && chkdsk >> %WinDir%\Temp\" & @MDAY & @MON & @YEAR & @MIN & @SEC & "chkdsk.txt", "", "RunAs", @SW_MINIMIZE )
$hWinCHKDSK = WinWait("Administrator:  CHKDSK is Running ", "", 10)
Do
	$i = $i + 1
	Sleep(2500)
	If $i = 40 Then $i = 39
	ProgressSet($i, $i & "%")
	Sleep(500)
Until WinExists($hWinCHKDSK, "") = 0

Sleep(500)
$dCHKDSK = FileRead($sCHKDSK)
ProgressSet(40, 40 & "%")
#EndRegion
#Region CHKDSK Analysis - Data
If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "file records processed", 0, 0, 1, 1) <> "-1" Then
	$filerecords = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "file records processed", 0, 0, 1, 1)] ; 1361152
Else
	$filerecords = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "large file records processed", 0, 0, 1, 1) <> "-1" Then
	$largefilerecords = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "large file records processed", 0, 0, 1, 1)] ; 18001
Else
	$largefilerecords = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "bad file records processed", 0, 0, 1, 1) <> "-1" Then
	$badfilerecords = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "bad file records processed", 0, 0, 1, 1)] ; 0
Else
	$badfilerecords = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "reparse records processed", 0, 0, 1, 1) <> "-1" Then
	$reparserecords = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "reparse records processed", 0, 0, 1, 1)] ; 7737
Else
	$reparserecords = "Errors Found - Unable to pull value"
EndIf

Sleep(500)
ProgressSet(50, 50 & "%")

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "index entries processed", 0, 0, 1, 1) <> "-1" Then
	$indexentries = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "index entries processed", 0, 0, 1, 1)] ; 1901846
Else
	$indexentries = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "files scanned", 0, 0, 1, 1) <> "-1" Then
	$unindexedscanned = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "files scanned", 0, 0, 1, 1)] ; 0
Else
	$unindexedscanned = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "recovered to lost and found", 0, 0, 1, 1) <> "-1" Then
	$unindexedfound = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "recovered to lost and found", 0, 0, 1, 1)] ; 0
Else
	$unindexedfound = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "data files processed", 0, 0, 1, 1) <> "-1" Then
	$datafilesprocessed = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "data files processed", 0, 0, 1, 1)] ; 270348
Else
	$datafilesprocessed = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "USN bytes processed", 0, 0, 1, 1) <> "-1" Then
	$USNbytes = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "USN bytes processed", 0, 0, 1, 1)] ; 38261408
Else
	$USNbytes = "Errors Found - Unable to pull value"
EndIf

If _ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "Windows has ", 0, 0, 1, 1) <> "-1" Then
	$filesystemscanned = StringSplit($dCHKDSK, @CRLF & "=")[_ArraySearch(StringSplit($dCHKDSK, @CRLF & "="), "Windows has ", 0, 0, 1, 1)] ;
Else
	$filesystemscanned = "Errors Found - Unable to pull value"
EndIf
#EndRegion
#Region CHKDSK Analysis - MetaData
$mdata = "----------------------------------" & @CRLF & "   MAGIC Analysis" & @CRLF & "----------------------------------"
$mdata = $mdata & @CRLF & "CHKDSK: " & $filesystemscanned
;~ $mdata = $mdata & @CRLF & $dCHKDSK & @CRLF
$cdata = "----------------------------------" & @CRLF & "   CHKDSK Analysis" & @CRLF & "----------------------------------"
$cdata = $cdata & @CRLF & "Stage 1: Examining basic file system structure ..."
$cdata = $cdata & @CRLF & $filerecords
If $filerecords <> "Errors Found - Unable to pull value" Then $cdata = $cdata & @CRLF & "File verification completed."
$cdata = $cdata & @CRLF & $largefilerecords
$cdata = $cdata & @CRLF & $badfilerecords
$cdata = $cdata & @CRLF
$cdata = $cdata & @CRLF & "Stage 2: Examining file name linkage ..."
$cdata = $cdata & @CRLF & $reparserecords
$cdata = $cdata & @CRLF & $indexentries
If $indexentries <> "Errors Found - Unable to pull value" Then $cdata = $cdata & @CRLF & "Index verification completed."
$cdata = $cdata & @CRLF & $unindexedscanned
$cdata = $cdata & @CRLF & $unindexedfound
$cdata = $cdata & @CRLF
$cdata = $cdata & @CRLF & "Stage 3: Examining security descriptors ..."
$cdata = $cdata & @CRLF & $datafilesprocessed
$cdata = $cdata & @CRLF & $USNbytes
If $USNbytes <> "Errors Found - Unable to pull value" Then $cdata = $cdata & @CRLF & "Usn Journal verification completed."
$cdata = $cdata & @CRLF & $filesystemscanned

$rdata = "----------------------------------" & @CRLF & "   RAW - CHKDSK Analysis" & @CRLF & "----------------------------------"
$rdata = $rdata & @CRLF & @CRLF & $dCHKDSK

$data = $mdata & @CRLF & @CRLF & $cdata

#EndRegion
#Region CHKDSK Analysis - Finalizing
GUICtrlSetData($g_idMemo, $data)
Sleep(500)
ProgressSet(90, 90 & "%")
Sleep(3000)
If $filesystemscanned = "Errors Found - Unable to pull value" Then ShellExecuteWait(@ComSpec, "/c title CHKDSK Scheduled Fix && echo Y | chkdsk /F" & @MDAY & @MON & @YEAR & @MIN & @SEC & "chkdsk.txt", "", "RunAs")
If $filesystemscanned = "Windows has checked the file system and found problems." Then ShellExecuteWait(@ComSpec, "/c title CHKDSK Scheduled Fix && echo Y | chkdsk /F" & @MDAY & @MON & @YEAR & @MIN & @SEC & "chkdsk.txt", "", "RunAs")
If $filesystemscanned = "Windows has scanned the file system and found no problems." Then MsgBox(0, "Disk Success", "Check Disk looks good", 5)
ProgressSet(100, 100 & "%")
Sleep(500)
ProgressOff()
#EndRegion CHKDSK Analysis - Ending


#Region SFC Analysis
$i = 20
ProgressOn("Administrator: MAGIC Analyzer", "Running Analysis (SFC /SCANNOW)" & @CRLF & "..." , "0%", -1, -1, $WS_POPUP)
$sSFCSCAN = @WindowsDir & "\Temp\" & @MDAY & @MON & @YEAR & @MIN & @SEC & "sfc.txt"
ProgressSet(20, 20 & "%")
$pWinSFCSCAN = ShellExecute(@ComSpec & " /c sfc", "/scannow" & @MDAY & @MON & @YEAR & @MIN & @SEC & "sfc.txt", "", "RunAs", @SW_MINIMIZE )
$hWinSFCSCAN = WinWait("Administrator:  SFC is Running ", "", 10)
Do
	$i = $i + 1
	Sleep(2500)
	If $i = 40 Then $i = 39
	ProgressSet($i, $i & "%")
	Sleep(500)
Until WinExists($hWinSFCSCAN, "") = 0

Sleep(500)
$dSFCSCAN = FileRead($sSFCSCAN)
ProgressSet(40, 40 & "%")
#EndRegion
#Region SFC Analysis - Data

#EndRegion
#Region SFC Analysis - MetaData

#EndRegion
#Region SFC Analysis - Finalizing

#EndRegion SFC Analysis - Ending

#Region Raw Data - Finalizing
ProgressOn("Administrator: MAGIC Analyzer", "Adding Raw Analysis" & @CRLF & "..." , "0%", -1, -1, $WS_POPUP)
$i = 0
Do
	$i = $i + 10
	ProgressSet($i, $i & "%")
	Sleep(500)
Until $i = 100
$data = $mdata & @CRLF & @CRLF & $cdata & @CRLF & @CRLF & $rdata
Sleep(500)
GUICtrlSetData($g_idMemo, $data)
ProgressOff()
#EndRegion Raw Data - Ending

#Region GUI Case Loop
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit


	EndSwitch
WEnd
#EndRegion GUI Closing - End
