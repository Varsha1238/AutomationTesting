Option Explicit
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'Function List
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'		Function Name									|     Developer					|		Date	|	Comment
'- - - - - - - - - - - - - - - - - - - - - - - - - - - -| - - - - - - - - - - - - - - - | - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'001. 	Fn_CommonUtil_EnvironmentVariablesOperations	|	pritish.nandi@sqs.com	|	16-Jan-2015	|	Function used to perform operations on local machine\systems environment variables 
'002. 	Fn_CommonUtil_DataTableOperations				|	pritish.nandi@sqs.com		|	24-Feb-2016	|	Function used to perfrom operations on datatable
'003. 	Fn_CommonUtil_KeyBoardOperation					|	pritish.nandi@sqs.com		|	25-Feb-2016	|	Function used to perfrom the keypress function on selected node
'004. 	Fn_CommonUtil_GetCursorStateState				|	pritish.nandi@sqs.com		|	25-Feb-2016	|	Function used to get cursor current state
'005. 	Fn_CommonUtil_CursorReadyStatusOperation		|	pritish.nandi@sqs.com		|	25-Feb-2016	|	Function used to perform operation on cursor ready status
'006. 	Fn_CommonUtil_WindowsApplicationOperations		|	pritish.nandi@sqs.com		|	25-Feb-2016	|	Function used to perform operations on running processes
'007. 	Fn_CommonUtil_GenerateRandomNumber				|	pritish.nandi@sqs.com	|	09-Mar-2016	|	Function used to generate random number
'008. 	Fn_CommonUtil_GenerateRandomString				|	pritish.nandi@sqs.com	|	09-Mar-2016	|	Function used to Generate Random String of given length
'009. 	Fn_CommonUtil_MouseWheelRotationOperations		|	pritish.nandi@sqs.com	|	09-Mar-2016	|	Function used to scroll mouse wheel up/down
'010. 	Fn_CommonUtil_StringArrayOperations				|	pritish.nandi@sqs.com	|	09-Mar-2016	|	Function used to perform operations on string array
'011. 	Fn_CommonUtil_LocalMachineOperations			|	pritish.nandi@sqs.com	|	09-Mar-2016	|	Function used to perform operations on local computer
'012. 	Fn_CommonUtil_AddDivider						|	pritish.nandi@sqs.com	|	10-Mar-2016	|	Function used to add divider
'013. 	Fn_CommonUtil_ArrayStringContains				|	pritish.nandi@sqs.com	|	13-Sep-2016	|	Function used to verify specific value contains in string array
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header Start
'Function Name			 :	Fn_CommonUtil_EnvironmentVariablesOperations
'
'Function Description	 :	Function used to perform operations on local machine\systems environment variables 
'
'Function Parameters	 :  1.sAction		: Function action name to perform
'							2.sVariableType	: Environment variable type
'							3.sVariableName	: Environment variable name
'							4.sVariableValue: Environment variable value
'
'Function Return Value	 : 	True \ False \ Environment Variable value
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	Environment variable should exist
'
'Function Usage		     :  bReturn = Fn_CommonUtil_EnvironmentVariablesOperations("Set","User","AutomationDir","C:\GOG_AL_11.2")
'Function Usage		     :  bReturn = Fn_CommonUtil_EnvironmentVariablesOperations("Get","User","AutomationDir","")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  16-Jan-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
'Replacement for function : Fn_GetEnvValue,Fn_SetEnvValue ' Delete this comment once implementation is completed
Function Fn_CommonUtil_EnvironmentVariablesOperations(sAction,sVariableType,sVariableName,sVariableValue)
	'Declaring variables
	Dim objShell,objEnvironment
	Dim sVariableCurrentValue
	
	'Initially set function return value as False
	Fn_CommonUtil_EnvironmentVariablesOperations=False
	
	'Creating [ Shell ] object
	Set objShell = CreateObject("WScript.Shell")
	'Creating Environment Type object
	Set objEnvironment = objShell.Environment(sVariableType)
	
	Select Case sAction
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to set local machine environment variable
		Case "Set"
			objEnvironment(sVariableName) = sVariableValue
			Fn_CommonUtil_EnvironmentVariablesOperations=True
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to get local machine environment variable value
		Case "Get"
			sVariableCurrentValue = objEnvironment(sVariableName)
			If sVariableCurrentValue<>"" Then
				Fn_CommonUtil_EnvironmentVariablesOperations=sVariableCurrentValue
			End If
	End Select
	
	If Err.Number <> 0 Then
		Fn_CommonUtil_EnvironmentVariablesOperations = False
		Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>:  [ Fn_CommonUtil_EnvironmentVariablesOperations ] : Fail to perform operation [ " & Cstr(sAction) & " ] due to error number [ " & Cstr(Err.Number) & " ] with error description [ " & Cstr(Err.Description) & " ]")
	End If
	'Releasing above created objects
	Set objEnvironment = Nothing	
	Set objShell = Nothing
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_DataTableOperations
'
'Function Description	 :	Function used to perfrom operations on datatable
'
'Function Parameters	 :   1.sAction: Action name 
'						    2.sColumnName: Column name in datatable
'							3.sValue: Value to be set in datatable
'							4.iRowNumber: Datatable rownumber where data is to be stored
'
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	No
'
'Function Usage		     :	Call Fn_CommonUtil_DataTableOperations("IsColumnExist","User_Role","","")
'Function Usage		     :	Call Fn_CommonUtil_DataTableOperations("AddColumn","User_Group","","")
'Function Usage		     :	Call Fn_CommonUtil_DataTableOperations("SetValue","DesignID","WS_200369",2)
'Function Usage		     :	Call Fn_CommonUtil_DataTableOperations("getvalue","DesignID","",2)
'Function Usage		     :	Call Fn_CommonUtil_DataTableOperations("exportdatatable","","","")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi			    |  24-Feb-2016	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_DataTableOperations(sAction, sColumnName, sValue, iRowNumber)
	'Declaring Variables
	Dim iCounter
	Dim bFlag

	'Initially set function return value as False
	Fn_CommonUtil_DataTableOperations = False
	
	Select Case lcase(sAction)
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to check existance of Column in global sheet datatable
		Case "iscolumnexist"
			For iCounter = 1 To DataTable.GlobalSheet.GetParameterCount
				If DataTable.GlobalSheet.GetParameter(iCounter).Name = sColumnName Then
					Fn_CommonUtil_DataTableOperations = True
					Exit For
				End If
			Next
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to Add Column in global sheet datatable
		Case "addcolumn"
			bFlag = False
			For iCounter = 1 To DataTable.GlobalSheet.GetParameterCount
				If DataTable.GlobalSheet.GetParameter(iCounter).Name = sColumnName Then
					bFlag = True
					Exit For
				End If
			Next
			If bFlag = False Then
				DataTable.GlobalSheet.AddParameter sColumnName,sValue
			End If
			Fn_CommonUtil_DataTableOperations = True
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to set value in global sheet datatable
		Case "setvalue"
			If iRowNumber <> "" Then
				DataTable.GlobalSheet.SetCurrentRow iRowNumber
			End If
			DataTable.Value(sColumnName,"Global") = sValue
			Fn_CommonUtil_DataTableOperations = True
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to get value in global sheet datatable
		Case "getvalue"
			If iRowNumber <> "" Then
				DataTable.GlobalSheet.SetCurrentRow iRowNumber
			End If
			Fn_CommonUtil_DataTableOperations = DataTable.Value(sColumnName,"Global")
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to export global sheet datatable
		Case "exportdatatable"
			If sValue = "" Then
				sValue = Fn_Setup_GetAutomationFolderPath("TestData")
			End If
			DataTable.ExportSheet  sValue & "\" &  Environment.Value("TestName") & ".xls","Global"
			Fn_CommonUtil_DataTableOperations = True
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to handle invalid request
		Case Else
			Exit Function
	End Select
	If Err.Number <> 0 Then
		Fn_CommonUtil_DataTableOperations = False
	End If
End Function

'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_KeyBoardOperation
'
'Function Description	 :	Function used to perfrom the keypress function on selected node
'
'Function Parameters	 :   1.sAction: Action name 
'						   	 2.sKey: Key Name
'
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	No
'
'Function Usage		     :	Call Fn_CommonUtil_KeyBoardOperation("SendKey", "^(c)")
'Function Usage		     :	Call Fn_CommonUtil_KeyBoardOperation("SendKeys", "^(c)~^(v)") 'Use ~ as seperator. Do not use ~ for {ENTER}
'Function Usage		     :	Call Fn_CommonUtil_KeyBoardOperation("PressKey", 28) '28 = Enter
'Function Usage		     :	Call Fn_CommonUtil_KeyBoardOperation("PressKeyAndSendString", "%~T~r~p")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi			    |  25-Feb-2016	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_KeyBoardOperation(sAction, sKey)
	'Declaring Variables
	Dim aKey, aKeySet
	Dim iCount
	Dim WshShell
	Dim objDeviceReplay
	Dim objDefaultWindow
	
	'Initially set function return value as False
	Fn_CommonUtil_KeyBoardOperation = False
	
	'Creating object of Teamcenter Default Window
	Set objDefaultWindow = JavaWindow("title:=.* - Teamcenter .*","tagname:=.* - Teamcenter .*","resizable:=1","index:=0")
	
	'Following cases used to send key stroke to the active window
	Select Case lcase(sAction)
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Case "sendkey"
			If Fn_UI_Object_Operations("Fn_CommonUtil_KeyBoardOperation","Exist",objDefaultWindow,"","","") Then
				objDefaultWindow.Click 150, 3, "LEFT"
				'Creating Shell object
				Set WshShell = CreateObject("WScript.Shell")
				WshShell.SendKeys sKey
				wait(GBL_MIN_MICRO_TIMEOUT)
				'Release Shell Object
				Set WshShell = Nothing
				If Err.Number <> 0 Then
					Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>: [ Fn_CommonUtil_KeyBoardOperation ] : Failed to Send Keystroke [" + sKey + "] on teamcenter application due to error number [ " & Cstr(Err.Number) & " ] with error description [ " & Cstr(Err.Description) & " ]" )
					Exit function
				Else	
					Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"), "PASS >> Successfully Operated Keystroke [" + sKey + "] On Teamcenter Application")
				End If
			Else
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"), "<FAIL>: [ Fn_CommonUtil_KeyBoardOperation ] : Teamcenter Application Window Not Found" )
				Exit function
			End If			
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Case "presskey"
			aKey = Split(sKey, ":", -1, 1)
			If Fn_UI_Object_Operations("Fn_CommonUtil_KeyBoardOperation","Exist",objDefaultWindow,"","","") Then
				objDefaultWindow.Click 150, 3, "LEFT"
				If ubound(aKey) > 0 Then
					objDefaultWindow.PressKey aKey(0), aKey(1)
				Else
					objDefaultWindow.PressKey aKey(0)
				End If
				If Err.Number <> 0 Then
					Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"), "<FAIL>: [ Fn_CommonUtil_KeyBoardOperation ] : Failed to Send Keystroke [" + sKey + "] on teamcenter application due to error number [ " & Cstr(Err.Number) & " ] with error description [ " & Cstr(Err.Description) & " ]" )
					Exit function
				Else	
					Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"), "PASS >> Successfully Operated Keystroke [" + sKey + "] On Teamcenter Application")
				End If
			Else
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"), "<FAIL>: [ Fn_CommonUtil_KeyBoardOperation ] : Teamcenter Application Window Not Found" )
				Exit function
			End If
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Case "sendkeys"
			aKeySet = split(sKey,"~")
			'Creating Shell Object
			Set WshShell = CreateObject("WScript.Shell")
			For iCount = 0 to UBound(aKeySet)
				WshShell.SendKeys aKeySet(iCount)								
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"), "PASS >> Successfully Operated Keystroke [" + aKeySet(iCount) + "] On Teamcenter Application")
				Wait(GBL_MICRO_TIMEOUT)
			Next
			'Release Shell Object
			Set WshShell = Nothing
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Case "presskeyandsendstring"
			aKeySet = split(sKey,"~")
			Select Case aKeySet(0)
				Case "%","LEFT ALT"
					aKeySet(0)="56"
			End Select
			'Creating Device Replay Object
			Set objDeviceReplay = CreateObject("Mercury.DeviceReplay")
			objDeviceReplay.PressKey aKeySet(0)
			Wait GBL_MICRO_TIMEOUT
			For iCount = 1 to UBound(aKeySet)
				objDeviceReplay.SendString aKeySet(iCount)
				Wait GBL_MICRO_TIMEOUT	
			Next
			'Release Object
			Set objDeviceReplay = Nothing
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to handle invalid request
		Case Else
			Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>: [ Fn_CommonUtil_KeyBoardOperation ] : [No valid case] : No valid case was passed for function [Fn_CommonUtil_KeyBoardOperation]")
	End Select
	
	If Err.Number <> 0 Then
		 Fn_CommonUtil_KeyBoardOperation = False
		Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>: [ Fn_CommonUtil_KeyBoardOperation ] : Due to error number [ " & Cstr(Err.Number) & " ] with error description [ " & Cstr(Err.Description) & " ]")
	Else	
		Fn_CommonUtil_KeyBoardOperation = True
	End If
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_GetCursorStateState
'
'Function Description	 :	Function used to get cursor current state
'
'Function Parameters	 :  NA
'
'Function Return Value	 : 	Cursor current state number
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn = Fn_CommonUtil_GetCursorState()
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi			    |  25-Feb-2016	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_GetCursorState()
	'Declaring Variables
	Dim iWindowHandle,iProcessID,iThreadID
	
	extern.Declare micLong,"GetForegroundWindow","user32.dll","GetForegroundWindow"
	extern.Declare micLong,"AttachThreadInput","user32.dll","AttachThreadInput", micLong, micLong,micLong
	extern.Declare micLong,"GetWindowThreadProcessId","user32.dll","GetWindowThreadProcessId", micLong, micLong
	extern.Declare micLong,"GetCurrentThreadId","kernel32.dll","GetCurrentThreadId"
	extern.Declare micLong,"GetCursor","user32.dll","GetCursor"

	iWindowHandle = extern.GetForegroundWindow()

	iProcessID = extern.GetWindowThreadProcessId(iWindowHandle, NULL)
	iThreadID = extern.GetCurrentThreadId()
	extern.AttachThreadInput iProcessID,iThreadID,True

	Fn_CommonUtil_GetCursorState = Eval("extern.GetCursor")

	extern.AttachThreadInput iProcessID,iThreadID,False
End function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_CursorReadyStatusOperation
'
'Function Description	 :	Function used to perfrom operation on cursor ready status
'
'Function Parameters	 :  1.iCursorState	: Cursor state
'						   	2.iIterations	: Number of iterations
'                           3.sCondition	: Condition to check
'
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn = Fn_CommonUtil_CursorReadyStatusOperation("","","")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi			    |  25-Feb-2016	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_CursorReadyStatusOperation(iCursorState, iIterations, sCondition)
 	'Declaring variables
	Dim iCount,iCounter
	
	'Initially set function return value as False
	Fn_CommonUtil_CursorReadyStatusOperation = False
	
	'Set the cursor state
	If iCursorState = "" Then
	   iCursorState = "65539"
	End If
	
	'Set the number of iterations
	If iIterations = "" Then
		iIterations = 1
	End If
	
	'Set the condition to check
	If sCondition = "" Then
		sCondition = "not equal"
	End If

	Select Case sCondition
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case for cursor ready status sync
		Case "not equal"
			For iCount = 1 to iIterations
				For iCounter = 1 To 25
					If CStr(Fn_CommonUtil_GetCursorState()) = CStr(iCursorState) Then
						Fn_CommonUtil_CursorReadyStatusOperation = True
						Exit For
					Else
						Wait GBL_MICRO_TIMEOUT
					End If
				Next
				If Fn_CommonUtil_CursorReadyStatusOperation Then
					Exit for
				End If
			Next
	End Select
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			:	Fn_CommonUtil_WindowsApplicationOperations
'
'Function Description	:	Function used to perform operations on running processes
'
'Function Parameters	:   1.sAction		: Action name 
'						    2.sApplication	: Application Name
'
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	No
'
'Function Usage		     :	Call Fn_CommonUtil_WindowsApplicationOperations("IsRunning", "EXCEL.EXE")
'Function Usage		     :	Call Fn_CommonUtil_WindowsApplicationOperations("Terminate", "EXCEL.EXE")
'Function Usage		     :	Call Fn_CommonUtil_WindowsApplicationOperations("TerminateAll", "EXCEL.EXE")
'Function Usage		     :	Call Fn_CommonUtil_WindowsApplicationOperations("TerminateAllExcel", "")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi			    |  25-Feb-2016	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_WindowsApplicationOperations(sAction, sApplication)
	'Declaring Variables
	Dim objAllProcess,objProcess

	'Initially set function return value as False
	Fn_CommonUtil_WindowsApplicationOperations = False
	
	Select Case lcase(sAction)
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to check if the given process is running or not running state
		Case "isrunning"
			'Creating object of Process
			Set objAllProcess = getobject("winmgmts:") 
			'Get all the processes running in your PC
			For Each objProcess In objAllProcess.InstancesOf("Win32_process")
				If (Instr (Ucase(objProcess.Name),uCase(sApplication)) = 1) Then 
					Fn_CommonUtil_WindowsApplicationOperations = True
					Exit for
				End If
			Next
			If Fn_CommonUtil_WindowsApplicationOperations = True Then
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"PASS >> [ Fn_CommonUtil_WindowsApplicationOperations ] Application [ " & sApplication & " ] is running.")	
			Else
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"PASS >> [ Fn_CommonUtil_WindowsApplicationOperations ] Application [ " & sApplication & " ] is not running.")	
			End If
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to close all excels
		Case "terminateallexcel"
			SystemUtil.CloseProcessByName("Excel.exe")
			Fn_CommonUtil_WindowsApplicationOperations = True
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to terminate process(s)
		Case "terminate", "terminateall"
			'Creating object of process
			Set objAllProcess = getobject("winmgmts:") 
			'Get all the processes running in your PC
			For Each objProcess In objAllProcess.InstancesOf("Win32_process")
				'Made all uppercase to remove ambiguity. Replace TASKMGR.EXE with your application name in CAPS.
				If (Instr(Ucase(objProcess.Name),uCase(sApplication)) = 1) Then 
					'You can replace this with Reporter.ReportEvent
					objProcess.Terminate
					Fn_CommonUtil_WindowsApplicationOperations = True
					If lcase(sAction) <> "terminateall" Then
						Exit for
					End If
				End If
			Next
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to handle invalid request
		Case Else
			Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>: [ Fn_CommonUtil_WindowsApplicationOperations ] :  [No valid case] : No valid case was passed for function [ Fn_CommonUtil_WindowsApplicationOperations ].")	
			Exit function
	End Select
	'Report any unexpected runtime error
	If Err.Number <> 0 Then
		Fn_CommonUtil_WindowsApplicationOperations = False
		Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>: [ Fn_CommonUtil_WindowsApplicationOperations ] : fail to perform operation [ " & Cstr(sAction) & " ] due to error number [ " & Cstr(Err.Number) & " ] with error description [ " & Cstr(Err.Description) & " ]")
	End If	
	'Release Object
	Set objAllProcess = Nothing
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header Start
'Function Name			 :	Fn_CommonUtil_GenerateRandomNumber
'
'Function Description	 :	Function used to generate random number 
'
'Function Parameters	 :  1.iLength : Random number lenght
'
'Function Return Value	 : 	Random number
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :  bReturn = Fn_CommonUtil_GenerateRandomNumber(3)
'Function Usage		     :  bReturn = Fn_CommonUtil_GenerateRandomNumber(7)
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  09-Mar-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_GenerateRandomNumber(iLength)
	'Declaring variables
	Dim iRandomNumber,iStartNumber,iCounter
	Randomize
	
	iStartNumber="9"
	For iCounter=1 To iLength-1
		iStartNumber=Cstr(iStartNumber)+"0"
	Next
	iRandomNumber = Int((iStartNumber * Rnd) + 1)
	
	If Len(Cstr(iRandomNumber)) < iLength Then
		Fn_CommonUtil_GenerateRandomNumber = "6" + Cstr(iRandomNumber)
	Else
		Fn_CommonUtil_GenerateRandomNumber = Cstr(iRandomNumber)
	End If
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_GenerateRandomString
'
'Function Description	 :	Function used to Generate Random String of given length
'
'Function Parameters	 :  1.iLength		: Random String Length
'							2.sLetterCase	: Random String Letter case
'
'Function Return Value	 : 	Random String
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn = Fn_CommonUtil_GenerateRandomString(6,"")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  09-Mar-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Function Fn_CommonUtil_GenerateRandomString(iLength,sLetterCase)
	'Declaring variables
	Dim sRandomString
	Dim iCounter
	
	Const sMainString= "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
	
	For iCounter = 1 to iLength
	  sRandomString=sRandomString & Mid(sMainString,RandomNumber(1,Len(sMainString)),1)
	Next
	
	If sLetterCase="Lower" Then
		Fn_CommonUtil_GenerateRandomString=Lcase(sRandomString)
	Else
		Fn_CommonUtil_GenerateRandomString=UCase(sRandomString)
	End If
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_MouseWheelRotationOperations
'
'Function Description	 :	Function used to scroll mouse wheel up/down
'
'Function Parameters	 :  1.iNumberOfRotation	: Number of times to rotate(-ve value for down, viceversa)
'
'Function Return Value	 : 	NA
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn = Fn_CommonUtil_MouseWheelRotationOperations(6)
'Function Usage		     :	bReturn = Fn_CommonUtil_MouseWheelRotationOperations(-3)
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  09-Mar-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Function Fn_CommonUtil_MouseWheelRotationOperations(iNumberOfRotation)
	'Declaring variables
    Const MOUSEEVENTF_WHEEL = 2048 	'@const long 	| MOUSEEVENTF_WHEEL | middle button up
    Const POSWHEEL_DELTA = 120 		'@const long 	| POSWHEEL_DELTA 	| movement of 1 mousewheel click Down<nl>
    Const NEGWHEEL_DELTA = -120 	'@const long	| NEGWHEEL_DELTA 	| movement of 1 mousewheel click Up<nl>
    Dim iCounter
    dim sMovementPosition
	
    Extern.Declare micVoid,"mouse_event","user32.dll","mouse_event",micLong,micLong,micLong,micLong,micLong
    
    If iNumberOfRotation > 0 then
		sMovementPosition="Down"
    End if
	
    For iCounter = 1 to Abs(iNumberOfRotation)
		If sMovementPosition="Down" then
			Extern.mouse_event MOUSEEVENTF_WHEEL,0,0,POSWHEEL_DELTA,0
		Else
			Extern.mouse_event MOUSEEVENTF_WHEEL,0,0,NEGWHEEL_DELTA,0
		End if
    Next
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_StringArrayOperations
'
'Function Description	 :	Function used to perform operations on string array
'
'Function Parameters	 :  1.sAction		: Action to perform on array
'							2.aStringData	: String array
'							3.sOrder		: Array order
'
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn=Fn_CommonUtil_StringArrayOperations("Sort",aStringData,"Ascending")
'Function Usage		     :	bReturn=Fn_CommonUtil_StringArrayOperations("VerifyOrder",aStringData,"Ascending")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  09-Mar-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_StringArrayOperations(sAction,ByRef aStringData,sOrder)
	'Declaring variables
	Dim iCount,iCounter
	Dim sTempValue
	
	Select Case (sAction)
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Case "", "Sort"
			If IsArray(aStringData)=True Then
				If sOrder="Descending" Then
					for iCount = UBound(aStringData) - 1 To 0 Step -1
						For iCounter= 0 to iCount
							If aStringData(iCounter)<aStringData(iCounter+1) then 
								sTempValue=aStringData(iCounter+1) 
								aStringData(iCounter+1)=aStringData(iCounter)
								aStringData(iCounter)=sTempValue 
							End if 
						  Next 
					  Next 
				Else
					 for iCount = UBound(aStringData) - 1 To 0 Step -1
						For iCounter= 0 to iCount
							  If aStringData(iCounter)>aStringData(iCounter+1) then 
								  sTempValue=aStringData(iCounter+1) 
								  aStringData(iCounter+1)=aStringData(iCounter)
								  aStringData(iCounter)=sTempValue 
							  End if 
						  Next 
					  Next 
				End If
				Fn_CommonUtil_StringArrayOperations=True
			Else
				Fn_CommonUtil_StringArrayOperations=False
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>:  [ Fn_CommonUtil_StringArrayOperations ] : Fail as given array is not standard format array due to which fail to sort array in [ " & Cstr(sOrder) & " ] oder")
			End If
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Case "VerifyOrder"
			Fn_CommonUtil_StringArrayOperations = True
			If IsArray(aStringData)=True Then
				If sOrder="Descending" Then
					For iCounter= 0 to UBound(aStringData)-1
						If aStringData(iCounter) >aStringData(iCounter+1) OR aStringData(iCounter) =aStringData(iCounter+1) then 
							'Do Nothing
						Else
							Fn_CommonUtil_StringArrayOperations = False
							Exit For
						End if 
					Next 
				Else
					For iCounter= 0 to UBound(aStringData)-1
						If aStringData(iCounter) < aStringData(iCounter+1) OR aStringData(iCounter) =aStringData(iCounter+1) then 
							'Do Nothing
						Else
							Fn_CommonUtil_StringArrayOperations = False
							Exit For
						End If 
					Next 
				End If
			Else
				Fn_CommonUtil_StringArrayOperations=False
				Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>:  [ Fn_CommonUtil_StringArrayOperations ] : Fail as given array is not standard format array due to which fail to sort array in [ " & Cstr(sOrder) & " ] oder")
			End If
	End Select
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_LocalMachineOperations
'
'Function Description	 :	Function used to perform operations on local computer
'
'Function Parameters	 :  1.sAction		: Action to perform
'							2.sValue		: Value
'
'Function Return Value	 : 	False\Computer Name\User name
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn=Fn_CommonUtil_LocalMachineOperations("getcurrentloginusername","")
'Function Usage		     :	bReturn=Fn_CommonUtil_StringArrayOperations("getcomputername","")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  09-Mar-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_LocalMachineOperations(sAction,sValue)
	'Variable Declaration
	Dim sNamingContext,sUserDN,sUserName
	Dim objRootDSE,objADSysInfo,objUser,objShell
	
	Fn_CommonUtil_LocalMachineOperations=False
	
	Select Case lCase(sAction)
		' - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - 
		'Case to get current login user to the local machine
		Case "getcurrentloginusername"
			If Environment("UserName")="" Then
				Set objRootDSE = GetObject("LDAP://RootDSE")
				If Err.Number = 0 Then 
					sNamingContext = objRootDSE.Get("defaultNamingContext")  
				Else 
					Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>:  [ Fn_CommonUtil_LocalMachineOperations ] : Fail to perform operation [ " & Cstr(sAction) & " ] due to error number [ " & Cstr(Err.Number) & " ] with error description [ " & Cstr(Err.Description) & " ]")
					Exit Function
				End If
				Set objADSysInfo = CreateObject("ADSystemInfo")
				sUserDN = objADSysInfo.username 
				Set objUser = Getobject("LDAP://" & sUserDN)
				sUserName = objUser.Get("givenName")  & " " & objUser.Get("sn")
				Set objUser = Nothing
				Set objADSysInfo = Nothing
				Set objRootDSE = Nothing
			Else
				sUserName=Environment("UserName")
			End If
			If sUserName<>"" Then
				Fn_CommonUtil_LocalMachineOperations=sUserName
			End If
		' - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - 
		'Case to get computer name
		Case "getcomputername"
			Set objShell = CreateObject( "WScript.Shell" )
			If objShell.ExpandEnvironmentStrings( "%COMPUTERNAME%" )<>"" Then
				Fn_CommonUtil_LocalMachineOperations= objShell.ExpandEnvironmentStrings( "%COMPUTERNAME%" )
			End If
			Set objShell =Nothing
	End Select	
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_AddDivider
'
'Function Description	 :	Function used to add divider
'
'Function Parameters	 :  1.sDivider		: Divider type
'							2.iDividerCount	: Divider count
'
'Function Return Value	 : 	Divider
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn=Fn_CommonUtil_AddDivider("Tab","3")
'Function Usage		     :	bReturn=Fn_CommonUtil_AddDivider("NewLine","")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  10-Mar-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Function Fn_CommonUtil_AddDivider(sDivider,iDividerCount)
	'Declaring variables
	Dim sTempDivider
	Dim iCounter
	If iDividerCount="" Then
		iDividerCount=0
	End If
	Select Case Lcase(sDivider)
		Case "tab"
			For iCounter = 0 to iDividerCount
				sTempDivider = sTempDivider & vbTab
			Next
			Fn_CommonUtil_AddDivider=sTempDivider
		Case "newline"
			For iCounter = 0 to iDividerCount				
				sTempDivider = sTempDivider & vblf
			Next
			Fn_CommonUtil_AddDivider=sTempDivider
	End Select	
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_CommonUtil_ArrayStringContains
'
'Function Description	 :	Function used to verify specific value contains in string array
'
'Function Parameters	 :  1.sString		: String Array
'							2.sValue		: String value
'							3.sSeparator	: Array seperator
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :	bReturn=Fn_CommonUtil_ArrayStringContains("Ab;dc;zx;wt","zx",";")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  13-Sep-2016	    |	 1.0		|	Minal N			 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_CommonUtil_ArrayStringContains(sString,sValue,sSeparator)
	'Declaring variables
	Dim iCounter
	Dim aValues
	Fn_CommonUtil_ArrayStringContains = False
	aValues = split(sString, sSeparator)
	For iCounter = 0 to UBound(aValues)
		If aValues(iCounter) = sValue Then
			Fn_CommonUtil_ArrayStringContains = True
			Exit for
		End If
	Next
End Function


'-------------------------------------------
''Function to send mail
''Example: Call Fn_MailUtil_SendEmail("pritish.nandi-ext@man.eu","pritish.nandi@sqs.com;Lothar.Zizala@man.eu","","Testing Mail","Test Autogenerated mail","")
'-------------------------------------------
Function Fn_MailUtil_SendEmail(sSendFrom,sSendTo,sSendCC,sSubject,sHTMLBody,sAttachmentPath)
                'Declaring variables
                Dim aAttachmentPath
                Dim iCounter
                Dim objMessage
                
                Fn_MailUtil_SendEmail=False
                
                'Creating object of CDO
                Set objMessage = CreateObject("CDO.Message")
                
                'This section provides the configuration information for the remote SMTP server.
                'Normally you will only change the server name or IP.
                objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
                
                'Name or IP of Remote SMTP Server
                'please pass valid smptserver name here
                objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "openrelay.mn-man.biz"
                
                'Server port (typically 25)
                objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
                
                objMessage.Configuration.Fields.Update
                objMessage.Subject = sSubject
                objMessage.From = sSendFrom
                objMessage.To = sSendTo
                objMessage.CC = sSendCC
  		objMessage.HTMLBody = sHTMLBody
    'objMessage.AddAttachment sAttachmentPath
    If sAttachmentPath<>"" Then
                aAttachmentPath=Split(sAttachmentPath,";")
                For iCounter=0 To Ubound(aAttachmentPath)
                                objMessage.AddAttachment aAttachmentPath(iCounter)                                                              
                Next
    End If
                objMessage.Send
                Set objMessage = Nothing
                Fn_MailUtil_SendEmail = True
End Function
