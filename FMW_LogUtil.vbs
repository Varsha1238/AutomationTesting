Option Explicit
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'Function List
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'			Function Name																|     Developer					|		Date	|	Comment
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'002. Fn_LogUtil_CreateTestCaseLogFile													|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function Used to create test case log file
'003. Fn_LogUtil_PrintAndUpdateScriptLog												|   pritish.nandi@sqs.com	|	11-Feb-2016 |	Function Used to update Test Case Log file, batch excel and mic report
'004. Fn_LogUtil_UpdateQCStepLog														|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function used to update step by step test case log in QC
'005. Fn_LogUtil_UploadAttachmentInQCOperations											|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function used to upload attachmenta in QC\ALM test set in test lab
'006. Fn_LogUtil_UpdateTestCaseBatchExecutionResult										|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function used to update test case result in batch execution detail excel file
'007. Fn_LogUtil_CaptureFunctionExecutionTime											|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function Used to calculate function performance time
'008. Fn_LogUtil_PrintStepHeaderLog														|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function use to print step header information in test case
'009. Fn_LogUtil_PrintTestCaseHeaderLog													|	pritish.nandi@sqs.com	|	16-Jan-2015 |	Function use to print step header information in test case
'010. Fn_LogUtil_CreateBatchExecutionResultSummarySheet									|	pritish.nandi@sqs.com	|	04-Apr-2016 |	Function Used to create batch execution result excel
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header Start
'Function Name			 :	Fn_LogUtil_CreateTestCaseLogFile
'
'Function Description	 :	Function Used to create test case log file
'
'Function Parameters	 :  1.sLogFileName	: Test case log file name
'
'Function Return Value	 : 	Test case log file path or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	Valid test case log file name
'
'Function Usage		     :  bReturn = Fn_LogUtil_CreateTestCaseLogFile(Environment.Value("TestName") & ".log")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  16-Jan-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
'Replacement for function : Fn_CreateLogFile ' Delete this comment once implementation is completed
Public Function Fn_LogUtil_CreateTestCaseLogFile(sLogFileName)
	'Declaring variables
	Dim sFilePath
	Fn_LogUtil_CreateTestCaseLogFile=False
	'Test case log file path
	If Environment.Value("BatchResultFolder") <> "" Then
		sFilePath = Environment.Value("BatchResultFolder") & "\" & sLogFileName
	ElseIf Environment.Value("TestName")="TC18_SystemCheckForWindchill" Then
		sFilePath = Environment.Value("Reports") & "\" & sLogFileName
	Else
		sFilePath = Environment.Value("Reports") & "\" & sLogFileName
	End If
	
	If Len(sFilePath )>259 Then
		sLogFileName=Mid(sLogFileName,1,240-Len(Environment.Value("BatchResultFolder"))) & "_SHORTEN" & ".log"
		sFilePath = Environment.Value("BatchResultFolder") & "\" & sLogFileName
	End If
	'Creting test case log file	
	Fn_LogUtil_CreateTestCaseLogFile=Fn_FSOUtil_FileOperations("createfile",sFilePath,"","")
	Environment.Value("TestLogFile")=sFilePath
End Function

''-----------------------------------------------------------------------------------------------------------------------------------------------
''Specific for System Check Test
'------------------------------------------------------------------------------------------------------------------------------------------------
Public Function Fn_LogUtil_CreateTestLogFile(sFilePath,sLogFileName)
	'Declaring variables
	'Dim sFilePath
	Fn_LogUtil_CreateTestLogFile=False
	'Test case log file path
	If sFilePath= "" Then
		sFilePath = Environment.Value("Reports") & "\" & sLogFileName
	Else
		sFilePath = sFilePath & "\" & sLogFileName
	End If 
	
	If Len(sFilePath )>259 Then
		sLogFileName=Mid(sLogFileName,1,240-Len(Environment.Value("Reports"))) & "_SHORTEN" & ".log"
		sFilePath = Environment.Value("Reports") & "\" & sLogFileName
	End If
	'Creting test case log file	
	Fn_LogUtil_CreateTestLogFile=Fn_FSOUtil_FileOperations("createfile",sFilePath,"","")
	Environment.Value("TestLogFile")=sFilePath
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			:	Fn_LogUtil_PrintAndUpdateScriptLog
'
'Function Description	:	Function used to update Test Case Log file, batch excel and mic report.
'
'Function Parameters	:   1.sLogType: Type of the log
'						    2.sTestLogComment: Log statements to be entered in test log file
'							3.sStepName: Step name for which log need to be print
'							4.bKillTCSession: Boolean variable option for Teamcenter session kill
'							5.bExitTest: Boolean variable option for Exit test iteration
'							6.iReadystatusIterations: Number of iteration for ready status of app
'							7.sAppName: App Name to kill or Iterate syncronization
'
'Function Return Value	 : 	True or False
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	No
'
'Function Usage		     :	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfull created item","Item creation","","","","1","RAC")
'Function Usage		     :	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfull verified item is created","Item creation","","","","1","RAC")
'Function Usage		     :	Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Fail to create item","Item creation","true","true","","","WEB")
'Function Usage		     :	Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Fail to verify item is created","Item creation","true","true","","","WEB")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  28-Nov-2017	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_LogUtil_PrintAndUpdateScriptLog(sLogType, sTestLogComment, sStepName, bKillTCSession, bExitTest, iReadystatusIterations, sAppName)
	'Declaring Variables
	Dim objFSO, objFile
	Dim sFileName, sImagePath, sBatchLogComment,strResultSheetLocation,strMailSub,strMailBody,strSendFromAdd, strSendToAdd, strSendCCAdd
	Dim aAppName, aIterations
	Dim iTotalTestExecutionTime, iTestExecutionMins, iTestExecutionSec
	Dim iCounter
	
	'Setting varibales to initial value
	If lcase(sLogType) <> "step_header" or lcase(sLogType) <> "updatelog" Then
		If sStepName = "" Then
			sStepName = Cstr(GBL_STEP_NUMBER)
		End If
	End If
	sBatchLogComment = ""
	
	'Setting variables to handle FAIL action
	If lcase(sLogType) = "fail_verification" or lcase(sLogType) = "fail_action" Then
		If bExitTest = "" Then
			bExitTest ="true"
			GBL_SCRIPT_RESULT="FAIL"
		End If
	End If
	
	On Error Resume Next
	'Creating object of File system
	If lCase(Environment.Value("StepLog")) = "true" Then
		Set objFSO = CreateObject("Scripting.FileSystemObject")
		sFileName = Environment.Value("TestLogFile")
		Set objFile = objFSO.OpenTextFile(sFileName,8)
	End If
	
	Select Case lcase(sLogType)
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to print Step header in Log file
		Case "step_header"
			If lCase(Environment.Value("StepLog")) = "true" Then
				'objFile.WriteLine vbNewLine
				objFile.WriteLine "-----------------------------------------------------------------------------------------------"
				objFile.WriteLine sTestLogComment	
				objFile.WriteLine "-----------------------------------------------------------------------------------------------"
			End If
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to update Log file
		Case "updatelog"
			If lCase(Environment.Value("StepLog")) = "true" Then
				objFile.WriteLine sTestLogComment	
			End If
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to print pass action in Log file
		Case "pass_action"
			If lCase(Environment.Value("StepLog")) = "true" Then
				objFile.WriteLine Time() & " - " & "Action - PASS [ "& sStepName &" ] | " & sTestLogComment
				GBL_SCRIPT_RESULT="PASS"				
			End If
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to print pass verification in Log file
		Case "pass_verification"
			If lCase(Environment.Value("StepLog")) = "true" Then
				objFile.WriteLine Time() & " - " & "Verify - PASS [ "& sStepName &" ] | " & sTestLogComment
				GBL_SCRIPT_RESULT="PASS"				
			End If
			GBL_VERIFICATION_COUNTER = GBL_VERIFICATION_COUNTER+1
			
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to print fail action in Log file
		Case "fail_action"
			If lCase(Environment.Value("StepLog")) = "true" Then
				objFile.WriteLine Time() & " - " & "Action - FAIL [ "& sStepName &" ] | " & sTestLogComment	
				If sBatchLogComment = "" Then
					sBatchLogComment = "FAIL: " & sTestLogComment
				Else
					sBatchLogComment = "FAIL: " & sBatchLogComment
				End If
				GBL_SCRIPT_RESULT="FAIL"
				If lcase(Environment.Value("BatchScheduler"))="true" Then
					strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
					Call Fn_Update_TestResult(strResultSheetLocation, sBatchLogComment, 1)
				End If
				Call Fn_Update_TestResult("",sBatchLogComment, 1)
				If Environment.Value("TestName")="TC18_SystemCheckForWindchill" Then
					Call Fn_PrintClosureLogExcel()
				Else
					Call Fn_PrintClosureLog()
				End If
			End If
			
			Reporter.ReportEvent micFail,sStepName,sTestLogComment
			Call Fn_CommonUtil_DataTableOperations("ExportDataTable","","","")
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to print fail verification in Log file
		Case "fail_verification"
			If lCase(Environment.Value("StepLog")) = "true" Then
				objFile.WriteLine Time() & " - " & "Verify - FAIL [ "& sStepName &" ] | " & sTestLogComment	
				If sBatchLogComment = "" Then
					sBatchLogComment = "FAIL: " & sTestLogComment
				Else
					sBatchLogComment = "FAIL: " & sBatchLogComment
				End If
				GBL_SCRIPT_RESULT="FAIL"
				If lcase(Environment.Value("BatchScheduler"))="true" Then
					strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
					Call Fn_Update_TestResult(strResultSheetLocation, sBatchLogComment, 1)
				End If
				Call Fn_Update_TestResult("",sBatchLogComment, 1)
				If Environment.Value("TestName")="TC18_SystemCheckForWindchill" Then
					Call Fn_PrintClosureLogExcel()
				Else
					Call Fn_PrintClosureLog()
				End If
			End If
			
			Reporter.ReportEvent micFail,sStepName,sTestLogComment
			Call Fn_CommonUtil_DataTableOperations("ExportDataTable","","","")
		' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		'Case to handle invalid request
		Case Else
			'Call Fn_LogUtil_UpdateDetailLog(Environment.Value("TestLogFile"),"<FAIL>:  [ Fn_LogUtil_PrintAndUpdateScriptLog ] : Fail to perform operation [ " & Cstr(sLogType) & " ] : No valid case was passed for function [Fn_LogUtil_PrintAndUpdateScriptLog] for Log Type")
	End Select
	
	'Setting Log update variable time to Now
	GBL_LAST_LOG_UPDATION_TIME = Now()
	GBL_TEST_EXECUTION_END_TIME=Now()	
	iTotalTestExecutionTime=GBL_TEST_EXECUTION_END_TIME - GBL_TEST_EXECUTION_START_TIME
	If lcase(Environment.Value("BatchScheduler"))="true" Then
		strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
		Call Fn_Update_TestResult(strResultSheetLocation, sBatchLogComment, 1)
	End If
	Call Fn_Update_TestResult("", sBatchLogComment, 1)
	
	'Uploading failure snapshot and log
	If Lcase(sLogType) = "fail_action" or Lcase(sLogType) = "fail_verification" Then
		'Uploading failure image
		
		If Environment.Value("TestName")="TC18_SystemCheckForWindchill" Then
			sImagePath = Environment.Value("SystemCheckReports") +"\"   & Environment.Value("TestLogFileName") & ".png"
			Desktop.CaptureBitmap sImagePath,True
		Else
			sImagePath = Environment.Value("BatchResultFolder") +"\"   & Environment.Value("TestName") & ".png"
			Desktop.CaptureBitmap sImagePath,True
		End If
		
	
		If lCase(Environment.Value("UploadFailImage")) = "true" Then            
			Call Fn_LogUtil_UploadAttachmentInQCOperations("Attach",sImagePath)
			objFile.WriteLine vbLF & Time() & " - " & "Test Script Failure Image Name := [ "& Environment.Value("TestName") &".png ]"
		End If
		
		If lCase(Environment.Value("UploadSysLogImage")) = "true" Then
			If GBL_SYSLOG_IMAGE_PATH<>"" Then
				If objFSO.FileExists(GBL_SYSLOG_IMAGE_PATH) Then
					Call Fn_LogUtil_UploadAttachmentInQCOperations("Attach",GBL_SYSLOG_IMAGE_PATH)
					objFile.WriteLine vbLF & Time() & " - " & "SysLog Image Name := [ "& Environment.Value("TestName") &"_SysLog.png ]"
				End If	
			End If
		End If	
		'uploading Log file
		If lCase(Environment.Value("UploadLog")) = "true" Then
			If lCase(Environment.Value("StepLog")) = "true" Then
                Call Fn_LogUtil_UploadAttachmentInQCOperations("Attach",Environment.Value("TestLogFile"))
			End If
		End If
	End If
	'Release Objects
	Set objFSO = Nothing
	Set objFile = Nothing
	
	'Killing application
	If lcase(bKillTCSession) = "true" Then
	End If

	'Exit from Test Case
	If lcase(bExitTest) = "true" AND Environment.Value("TestName")="TC18_SystemCheckForWindchill" Then
		strMailSub="Windchill is Down"
		strMailBody=Fn_SystemCheckEmailBody()
		strSendFromAdd=Environment.Value("EmailFromAddress")
		strSendToAdd=Environment.Value("EmailTOAddress")
		strSendCCAdd=Environment.Value("EmailCCAddress")
		
		Call Fn_MailUtil_SendEmail(strSendFromAdd, strSendToAdd, strSendCCAdd,strMailSub, strMailBody, sImagePath)
		Call Fn_ExitFromTest()
	ElseIf lcase(bExitTest) = "true" Then
		'ExitTest
		Call Fn_ExitFromTest()
	End If
	
	'Performing synchronization of application
	aAppName = Split(sAppName,"~")
	aIterations = Split(iReadystatusIterations,"~")
	For iCounter = 0 To ubound(aAppName)
		
	Next
	If iReadystatusIterations = "DONOTSYNC" Then
		iReadystatusIterations = ""
	End If
	GBL_LOG_ADDITIONAL_INFORMATION = ""
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header Start
'Function Name			 :	Fn_LogUtil_CaptureFunctionExecutionTime
'
'Function Description	 :	Function Used to calculate function performance time
'
'Function Parameters	 :  1.sAction:Action to be performed
'							2.sFunctionName: Function name
'							3.sFunctionActionName: Function Action name ( optional )
'							4.sParameterName : Parameter name ( optional )
'							5.sParameterValue : Parameter value ( optional )
'
'Function Return Value	 : 	Performance\Execution time
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	
'
'Function Usage		     :  Call Fn_LogUtil_CaptureFunctionExecutionTime("CaptureStartTime","Fn_ObjectDeleteOperations","Delete","","")
'Function Usage		     :  Call Fn_LogUtil_CaptureFunctionExecutionTime("CaptureEndTime","Fn_WorkflowProcess_Operation","","","")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  09-Feb-2016	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_LogUtil_CaptureFunctionExecutionTime(sAction,sFunctionName,sFunctionActionName,sParameterName,sParameterValue)
	'Declaring varaibles
	Dim iPerformanceDuration
	
	Select Case lCase(sAction)
	    '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
		Case "capturestarttime",""
			GBL_FUNCTION_EXECUTION_START_TIME=Now()
         '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
		Case "captureendtime"
			GBL_FUNCTION_EXECUTION_END_TIME=Now()
			If GBL_FUNCTION_EXECUTION_START_TIME<>"" Then
				iPerformanceDuration=Cstr(DateDiff("s",GBL_FUNCTION_EXECUTION_START_TIME,GBL_FUNCTION_EXECUTION_END_TIME))
			End If			
			GBL_FUNCTION_EXECUTION_START_TIME=""
			GBL_FUNCTION_EXECUTION_END_TIME=""
	End Select 
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header Start
'Function Name			 :	Fn_LogUtil_PrintStepHeaderLog
'
'Function Description	 :	Function use to print step header information in test case
'
'Function Parameters	 :  1.iStepNumber:Step number
'							2.sStepDescription: Step Description
'							3.sExpectedResult: Step Expected result
'
'Function Return Value	 : 	NA
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	NA
'
'Function Usage		     :  Call Fn_LogUtil_PrintStepHeaderLog(2,GBL_STEP_DESCRIPTION,GBL_STEP_EXPECTED_RESULT)
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	 Reviewer			|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  28-Nov-2017	    |	 1.0		|	pritish nandi	 	| 	Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Function Fn_LogUtil_PrintStepHeaderLog(iStepNumber,sStepDescription,sExpectedResult)
	If iStepNumber="" Then
		Exit Function
	End If
	'If QCStepLog Flag is true then print step information according to QC steps
	'Need to implement code
	If Cint(iStepNumber)=0 Then
		GBL_STEP_NUMBER=1
		Call Fn_LogUtil_PrintAndUpdateScriptLog("step_header","Step No. : " & Cstr(GBL_STEP_NUMBER) & vbNewLine & "Description : " & Cstr(sStepDescription) & vbNewLine & "Expected Result : " & Cstr(sExpectedResult),"","","","","")
	Else
		GBL_STEP_NUMBER = GBL_STEP_NUMBER + 1
		Call Fn_LogUtil_PrintAndUpdateScriptLog("step_header","Step No. : " & Cstr(GBL_STEP_NUMBER) & vbNewLine & "Description : " & Cstr(sStepDescription) & vbNewLine & "Expected Result : " & Cstr(sExpectedResult),"","","","","")
	End If
	GBL_STEP_DESCRIPTION=""
	GBL_STEP_EXPECTED_RESULT=""
End Function
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - @Function Header Start 
'Function Name			 :	Fn_LogUtil_PrintTestCaseHeaderLog
'
'Function Description	 :	Function used to print test case header log
'
'Function Parameters	 :  NA
'
'Function Return Value	 : 	NA
'
'Wrapper Function	     : 	NA
'
'Function Pre-requisite	 :	Test case log file should be exist
'
'Function Usage		     :	Call Fn_LogUtil_PrintTestCaseHeaderLog("")
'                       
'History			     :
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	Developer Name				|	Date			|	Rev. No.   	|	      Reviewer		|	Changes Done	
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
'	pritish nandi		    |  10-Mar-2016	    |	 1.0		|		pritish nandi	| 		Created
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -@Function Header End
Public Function Fn_LogUtil_PrintTestCaseHeaderLog()
	'Declaring variables
	Dim sParamName
	Dim iParamCount,iCounter
	Dim objNetWork,objFSO,objFile
	
	If Environment.Value("UserName")="" Then
	  Set objNetWork = CreateObject("WScript.NetWork") 
	  Environment.Value("UserName")=objNetWork.UserName
	  Set objNetWork = Nothing
	End If
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.OpenTextFile(Environment.Value("TestLogFile"),8)
	objFile.WriteLine "-----------------------------------------------------------------------------------------------"
	objFile.WriteLine "Test Case Information"
	objFile.WriteLine "-----------------------------------------------------------------------------------------------"
	objFile.WriteLine "TestCase" & " - " & Environment.Value("TestName")
	objFile.WriteLine "Test Run Date" & " - " & MonthName(Month(Date)) & "/" & Day(Date) & "/" & Year(Date)
	objFile.WriteLine "Test Run Time" & " - " & TimeSerial(Hour(Time) , Minute(Time), Second(Time))
	objFile.WriteLine "-----------------------------------------------------------------------------------------------"
	objFile.WriteLine "Test Script Logs"
	objFile.WriteLine "-----------------------------------------------------------------------------------------------"
	
	Set objFile =Nothing
	Set objFSO =Nothing	
End Function

Public Function Fn_PrintClosureLog()
	Dim TotalTestExecutionTime,strResultSheetLocation
	GBL_TEST_EXECUTION_END_TIME=Now()	
	
	TotalTestExecutionTime=datediff("s",GBL_TEST_EXECUTION_START_TIME,GBL_TEST_EXECUTION_END_TIME)
	If TotalTestExecutionTime > 60 Then
		TestExecutionMins=TotalTestExecutionTime/60
		TestExecutionMins=Split(Cstr(TestExecutionMins),".")
		TestExecutionSec=TotalTestExecutionTime-Cint(TestExecutionMins(0))*60
		TestExecutionMins(0)=Cint(TestExecutionMins(0))
		TestExecutionSec=Cint(TestExecutionSec)
	Else
		TestExecutionSec = TotalTestExecutionTime
		TestExecutionMins = Split("0")
	End If
	
	If TestExecutionSec < 0 Then
		TestExecutionSec = TestExecutionSec*(-1)
	End If
	
	
	Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updatescriptdetails","","","","",GBL_SCRIPT_RESULT, TestExecutionMins(0)&"mins"&TestExecutionSec&"secs")
	
	If GBL_SCRIPT_RESULT="PASS" Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog",vbNewLine,"","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","-----------------------------------------------------------------------------------------------","","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","[" & Cstr(time) & "] - Final - Pass | Test Execution Result: PASS","","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","[" & Cstr(time) & "] - Final - Pass | Test Execution Total Time : [ " & Cstr(TestExecutionMins(0)) & " ] Minute [ " & Cstr(TestExecutionSec) & " ] Seconds","","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","-----------------------------------------------------------------------------------------------","","","","","")				
		If lcase(Environment.Value("BatchScheduler"))="true" Then
			strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
			Call Fn_Update_TestResult(strResultSheetLocation,GBL_SCRIPT_RESULT&":All VP Pass", 1)
		End If
		Call Fn_Update_TestResult("",GBL_SCRIPT_RESULT&":All VP Pass", 1)
	End If
End Function

Public Function Fn_LogUtil_UpdateDetailLog(sFilePath,sText)
End Function
''--------------------------------------------------------------------------------------------------------------------
'' Function Number   	:                                                                              
'' Function Name     	: LoadEnvXML()
'' Function Description : Function used load external env xml
'' Function Usage    	: Result = LoadEnvXML()

'' Function History
''----------------------------------------------------------------------------------------------------------------------
''	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
''----------------------------------------------------------------------------------------------------------------------
'' 		|  12-Jan-2018	| 	1.0	 |									|				|  
''----------------------------------------------------------------------------------------------------------------------
Function LoadEnvXML()
	Dim sAutoDir
	sAutoDir=Fn_GetEnvValue("User", "AutomationDir")
	Environment.LoadFromFile(sAutoDir + "\AutomationXml\EnvironmentVariables.XML")
	LoadEnvXML = True
	Environment.Value("ExecutionStartTime")=Now()
End Function

'--------------------------------------------------------------------------------------------------------------------
' Function Number   	: 1                                                                                
' Function Name     	: Fn_Create_Folder
' Function Description  : Create folder
' Function Usage    	: Result = Fn_Create_Folder(strFolderPath)   
'							strFolderPath	- Path for folder creation on machine
'                     		return Folder Path on success
'--------------------------------------------------------------------------------------------------------------------
Public Function Fn_Create_Folder(strFolderPath)

	Dim objFSO
	Dim objFolder

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	If objFSO.FolderExists(strFolderPath) Then
		Set objFolder = objFSO.GetFolder(strFolderPath)
	Else
		Set objFolder = objFSO.CreateFolder(strFolderPath)
	End If 

	Set objFolder = Nothing
	Set objFSO = Nothing
 
	Fn_Create_Folder = strFolderPath

End Function
'--------------------------------------------------------------------------------------------------------------------
' Function Number   	: 13                                                                                
' Function Name     	: Fn_UpdateEnvXMLNode
' Function Description  : Update QTP Environment XML with the BatchResult folder path
' Function Usage    	: Result = Fn_UpdateEnvXMLNode(XMLDataFile, sNodeName, sNodeValue)
'							XMLDataFile	- Location of QTP Environment XML on test machine
'							sNodeName	- Node Name in XML (e.g. BatchFldName in QTP Environment XML)
'							sNodeValue	- Node Value for the sNodeName (e.g. BatchResult folder path)
'                     return True on success, False on failuer
'--------------------------------------------------------------------------------------------------------------------

Public Function Fn_UpdateEnvXMLNode(XMLDataFile, sNodeName, sNodeValue)

Dim objXMLDoc
Dim objChildNodes
Dim objSelectNode
Dim intNodeLength
Dim intNodeCount
Dim intChildNodeCount
Dim strNodeSting

set objXMLDoc=CreateObject("Microsoft.XMLDOM")												' Create XMLDOM object
objXMLDoc.async="false"
objXMLDoc.load(XMLDataFile)																	' Loading QTP Environment XML

If (objXMLDoc.parseError.errorCode <> 0) Then
	Fn_UpdateEnvXMLNode = False
Else
	intNodeLength = objXMLDoc.getElementsByTagName("Variable").length
	For intNodeCount = 0 to (intNodeLength - 1)
		Set objChildNodes = objXMLDoc.documentElement.childNodes.item(intNodeCount).childNodes
			strNodeSting = ""
			For intChildNodeCount = 0 to (objChildNodes.length - 1)
					strNodeSting = strNodeSting & objChildNodes(intChildNodeCount).text 
			Next
			If Instr(strNodeSting, sNodeName) Then
				Set objSelectNode = objXMLDoc.SelectSingleNode("/Environment/Variable[" & intNodeCount &"]/Value")
				objSelectNode.Text = sNodeValue
				Exit For
			End If
	Next
	objXMLDoc.Save(XMLDataFile)
	Set objSelectNode = nothing 
	Set objChildNodes = nothing
	Set objXMLDoc = nothing
	Fn_UpdateEnvXMLNode = True
End if	

End Function
''*********************************************************		Function to Kill all the Current User Processes		***********************************************************************
'Function Name		:				Fn_KillProc

'Description			 :		 		 The function is used to kill all the preferred processes owned by current user

'Parameters			   :	 			sProcessNames
											
'Return Value		   : 				Boolean

'Pre-requisite			:		 		None

'Examples				:				 Fn_KillProc("iexplore.exe:notepad.exe") 

'History:
'										Developer Name			Date					Revision			Changes Done			Reviewer	Reviewed  Date
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'										Mallikarjun		 		23-Dec-2010       		1.0					
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Public Function Fn_KillProc(sProcessNames)

			Dim objNetwork, currUser, User, Domain                                
			Dim sArrData,  iCount, strComputer,sImgPath
			Dim objWMIService, objProcess, colProcess
										
			sArrData = split(sProcessNames, ":",-1,1)

			Set objNetwork = CreateObject("Wscript.Network")
			currUser = objNetwork.UserName

			strComputer = "." 
			Set objWMIService = GetObject("winmgmts:" _
					    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

			For iCount = 0 to ubound(sArrData)
				Set colProcess = objWMIService.ExecQuery("Select * from Win32_Process Where Name ='"+ sArrData(iCount) +"'")  

				For Each objProcess in colProcess 
					If objProcess.GetOwner ( User, Domain ) = 0 Then
 						If LCase(User) = currUser then
							objProcess.Terminate()
						End If
					End If
				Next 
			Next

			Set objWMIService = Nothing
			Set objNetwork = Nothing
			Set colProcess = Nothing

			If Err.Number <> 0 Then
				Fn_KillProc =False
			Else
				Fn_KillProc =True
			End If
End Function

'***********************************************************************************************
'' Function Number   	: 25                                                                              
'' Function Name     	: Fn_GetEnvValue(sType, sEnvName)
'' Function Description : Function used to get the env values for the system
'' Function Usage    	: Result = Fn_GetEnvValue(sType, sEnvName)
''							sType		- User / System
''							sEnvName	- Name of the env variable (e.g. FMS_HOME, AutomationDir)
'' Function History
''----------------------------------------------------------------------------------------------------------------------
''	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
''----------------------------------------------------------------------------------------------------------------------
'' 		|  20-Sep-2010	| 	1.0	 |									|				|  
''----------------------------------------------------------------------------------------------------------------------
Public Function Fn_GetEnvValue(sType, sEnvName)

	Dim objShell
	Dim objUsrEnv
	Dim UserVar
	
	UserVar = ""
	
	Set objShell = CreateObject("WScript.Shell")
	Set objUsrEnv = objShell.Environment(sType)
		UserVar = objUsrEnv(sEnvName)
    Set objUsrEnv = Nothing
	Set objShell = Nothing
	
	if UserVar <> "" then
		Fn_GetEnvValue = UserVar
	else
		Fn_GetEnvValue = False
	end if				
End Function
'**********************************************************************************************************************
' Function Number   	: 7                                                                                
' Function Name     	: Fn_Update_TestDetail
' Function Description  : Update test details in batch result excel
' Function Usage    	: bReturn = Fn_Update_TestDetail(strResultSheetLocation, arrTestData(), intSheetNumber)
'							strResultSheetLocation	- Location of batch result excel
'							arrTestData				- Test array data 
'							intSheetNumber			- Sheet number in excel
'                     	return True on success, False on failuer
' Function History
'----------------------------------------------------------------------------------------------------------------------
'	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
'----------------------------------------------------------------------------------------------------------------------
' 		|  9-June-2010	| 	2.0	 |									|				|
'**********************************************************************************************************************

Public Function Fn_Update_TestDetail(strResultSheetLocation, arrTestData(), intSheetNumber)

	Const xlCellTypeLastCell = 11
	Const xlContinuous = 1
	Const xlCenter = -4108
	Const xlLeft = -4131	
   
	Dim objFile
	Dim objExcel
	Dim objWorkbook
	Dim objWorkSheet
	Dim objRange
	Dim iCount
    Dim sLinkAddress
	Dim objFSO
	Dim intRowId

	If  strResultSheetLocation = "" Then
		strResultSheetLocation=Environment.Value("BatchResultFolder") +"\BatchRunDetails.xlsx"
	End If
	
'	If lcase(Environment.Value("BatchScheduler"))="true" Then
'		strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
'	ElseIf strResultSheetLocation = "" Then
'		strResultSheetLocation=Environment.Value("BatchResultFolder") +"\BatchRunDetails.xlsx" 	
'	End If

		Set objFSO = CreateObject("Scripting.FileSystemObject")

		If objFSO.FileExists(strResultSheetLocation) Then

			Set objExcel = CreateObject("Excel.Application")

			objExcel.Visible = False
			objExcel.AlertBeforeOverwriting = False
			objExcel.DisplayAlerts = False
	
			Set objWorkbook = objExcel.Workbooks.Open(strResultSheetLocation)
	
			If intSheetNumber = "" Then
				 intSheetNumber = 1
			End If   
	
			Set objWorkSheet = objWorkbook.Worksheets(intSheetNumber)
			objWorkSheet.Activate
			
			Set objRange = objWorkSheet.UsedRange
			objRange.SpecialCells(xlCellTypeLastCell).Activate
			
			intRowId = objExcel.ActiveCell.Row + 1
	
			objWorkSheet.Cells(intRowId, 1).Value = intRowId - 1
			objExcel.Cells(intRowId, 1).HorizontalAlignment = xlCenter
			objExcel.Cells(intRowId, 1).VerticalAlignment = xlCenter
	
			For iCount = 1 to UBound(arrTestData)
				objWorkSheet.Cells(intRowId, (iCount + 1)).Value = arrTestData(iCount)
			Next
	
			objRange.Borders.LineStyle = xlContinuous
			objRange.Range("A1").Activate
	
			objWorkbook.Save
			objExcel.Quit

			Fn_Update_TestDetail = True

		Else

			Fn_Update_TestDetail = False

		End If

    Set objRange = Nothing
    Set objWorkSheet = Nothing
    Set objWorkbook = Nothing
    Set objExcel = Nothing
	Set objFSO = Nothing

End Function
'**********************************************************************************************************************
' Function Number   	: 8                                                                                
' Function Name     	: Fn_Update_TestResult
' Function Description  : Update test result in batch result excel
' Function Usage    	: bReturn = Fn_Update_TestResult(strResultSheetLocation, sResultData, intSheetNumber)
'							strResultSheetLocation	- Location of batch result excel
'							sResultData				- Test result data (PASS / FAIL and Verification Point Details) 
'							intSheetNumber			- Sheet number in excel
'                     	return True on success, False on failuer
' Function History
'----------------------------------------------------------------------------------------------------------------------
'	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
'----------------------------------------------------------------------------------------------------------------------
' 		|  9-June-2010	| 	2.0	 |									|				|
'**********************************************************************************************************************

Public Function Fn_Update_TestResult(strResultSheetLocation, sResultData, intSheetNumber)

	Const xlCellTypeLastCell = 11
	Const xlContinuous = 1
	Const xlCenter = -4108

	Dim objFile
	Dim objExcel
	Dim objWorkbook
	Dim objWorkSheet
	Dim objRange
	Dim iCount
	Dim objFSO,Status,arrStatus,result
	Dim sColumnId,sLog,EndTimeColumnId
	Dim arrResult, sShardPath, sBatFldPath
	Dim arrResultData(2)

		arrResult = Split(sResultData, ":", -1,1)
		
		If Ubound(arrResult) > 1 Then

			arrResultData(0) = arrResult(0)
			arrResultData(1) = ""
            
			For iCount = 1 to Ubound(arrResult)
				arrResultData(1) = arrResultData(1) & arrResult(iCount) & " "
			Next
		Else
			arrResultData(0) = arrResult(0)
			arrResultData(1) = arrResult(1)
		End If
		
'		If lcase(Environment.Value("BatchScheduler"))="true" Then
'			strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
'		ElseIf strResultSheetLocation = "" Then
'			strResultSheetLocation=Environment.Value("BatchResultFolder") +"\BatchRunDetails.xlsx" 	
'		End If
		
		If  strResultSheetLocation = "" Then
			strResultSheetLocation=Environment.Value("BatchResultFolder") +"\BatchRunDetails.xlsx"
		End If

		EndTimeColumnId = Fn_ExcelSearch(strResultSheetLocation, "EndTime", intSheetNumber)
		EndTimeColumnId = CInt(Fn_strUtil_SubField(EndTimeColumnId, ":", 1))

		sColumnId = Fn_ExcelSearch(strResultSheetLocation, "Result", intSheetNumber)
		sColumnId = CInt(Fn_strUtil_SubField(sColumnId, ":", 1))

		Set objFSO = CreateObject("Scripting.FileSystemObject")

		If objFSO.FileExists(strResultSheetLocation) Then

			Set objExcel = CreateObject("Excel.Application")
			objExcel.AlertBeforeOverwriting = False
	
			objExcel.Visible = False
			objExcel.DisplayAlerts = False
	
			Set objWorkbook = objExcel.Workbooks.Open(strResultSheetLocation)
	
			If intSheetNumber = "" Then
				 intSheetNumber = 1
			End If  
	
			Set objWorkSheet = objWorkbook.Worksheets(intSheetNumber)
			objWorkSheet.Activate
			
			Set objRange = objWorkSheet.UsedRange
			objRange.SpecialCells(xlCellTypeLastCell).Activate
			objWorkSheet.Cells(objExcel.ActiveCell.Row, EndTimeColumnId).Value = GBL_TEST_EXECUTION_END_TIME
			For iCount = 0 to (UBound(arrResultData)-1)
				objWorkSheet.Cells(objExcel.ActiveCell.Row, sColumnId).Value = Trim(arrResultData(iCount))
				If iCount = 0 Then
					objExcel.Cells(objExcel.ActiveCell.Row, sColumnId).Font.Bold = True
					objExcel.Cells(objExcel.ActiveCell.Row, sColumnId).HorizontalAlignment = xlCenter
					objExcel.Cells(objExcel.ActiveCell.Row, sColumnId).VerticalAlignment = xlCenter	
					If InStr(LCase(arrResultData(iCount)),"pass") <> 0 Then
						objExcel.Cells(objExcel.ActiveCell.Row, sColumnId).Interior.ColorIndex = 35
					ElseIf InStr(LCase(arrResultData(iCount)),"fail") <> 0 Then
						objExcel.Cells(objExcel.ActiveCell.Row, sColumnId).Interior.Color = RGB(255,128,128)
					End If				
				End If
				sColumnId = sColumnId + 1
			Next
'			''Log Path
			sLog="G"&objExcel.ActiveCell.Row
			with objExcel
				.Range(sLog).select
				.ActiveSheet.Hyperlinks.Add .Selection,Environment.Value("TestLogFile"),,Environment.Value("TestLogFile"),Environment.Value("TestLogFile")
			end with
			
			objRange.Borders.LineStyle = xlContinuous
			objRange.Range("A1").Activate
	
			objWorkbook.Save
			objExcel.Quit

			Fn_Update_TestResult = True

		Else
			Fn_Update_TestResult = False

		End IF

    Set objRange = Nothing
    Set objWorkSheet = Nothing
    Set objWorkbook = Nothing
    Set objExcel = Nothing
	Set objFSO = Nothing

End Function
'--------------------------------------------------------------------------------------------------------------------
' Function Number   	: 14                                                                                
' Function Name     	: Fn_ExcelSearch(sExcelPath, sSearchStr, iSheetNumber)
' Function Description  : Search for a specific string in the excel
' Function Usage    	: Result = Fn_ExcelSearch(sExcelPath, sSearchStr, intSheetNumber)
'							sExcelPath		- Location of Excel
'							sSearchStr		- Search string to be searched in Excel
'							intSheetNumber	- Excel sheet number
'                     return Cell id for the searched text (e.g. for "A1" it will return 1:1) on success, False on failuer       
'--------------------------------------------------------------------------------------------------------------------
Public Function Fn_ExcelSearch(sExcelPath, sSearchStr, iSheetNumber)

	Const xlCellTypeLastCell = 11
	
	Dim objExcel
	Dim objWorkbook
	Dim objWorksheet
	Dim iRowId, iColId
	
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(sExcelPath)
	objExcel.Visible = false
	objExcel.DisplayAlerts = False
	
	If iSheetNumber = "" Then
		 iSheetNumber = 1
	End If 
	
	Set objWorksheet = objWorkbook.Worksheets(iSheetNumber)
	objWorksheet.Activate
	objWorksheet.UsedRange.SpecialCells(xlCellTypeLastCell).Activate

	For iRowId = 1 To objExcel.ActiveCell.Row
        For iColId = 1 to objExcel.ActiveCell.Column
			If LCase(objExcel.Cells(iRowId, iColId).Value) = LCase(sSearchStr) Then
				Fn_ExcelSearch = iRowId &":"& iColId
				Exit For
			End If
		Next
	Next

	If Fn_ExcelSearch = "" Then
		Fn_ExcelSearch = False
	End If

	objExcel.Quit

	Set objWorksheet = Nothing
	Set objWorkbook = Nothing
	Set objExcel = Nothing

End Function
'--------------------------------------------------------------------------------------------------------------------
' Function Number   	: 17                                                                                
' Function Name     	: Fn_strUtil_SubField(expression, delimiter, intCount)
' Function Description  : Returns a substring
' Function Usage    	: Result = Fn_strUtil_SubField(expression, delimiter, intCount)
'							expression		- String expression containing substrings and delimiters. If expression is a zero-length string
'							delimiter		- String character used to identify substring limits
'							count 			- Number of delimiter after which substring is present in expression
'                     return Sub String on success, False on failuer     
' Function History
'----------------------------------------------------------------------------------------------------------------------
'	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
'----------------------------------------------------------------------------------------------------------------------
' 		|  03-May-2010	| 	1.0	 |									|				|  
'--------------------------------------------------------------------------------------------------------------------

Function Fn_strUtil_SubField(expression, delimiter, intCount)

	Dim strSubString

	If len(expression) = 0 Then
		Fn_strutil_SubField = False
	ElseIf Instr(expression, delimiter) = 0 Then
		Fn_strutil_SubField = False
	Else
		strSubString = split(expression, delimiter, -1, 1)
		If Ubound(strSubString) >= intCount Then
			Fn_strutil_SubField = strSubString(intCount)
		else
			Fn_strutil_SubField = False
		End If
	End If

End Function

''***********************************************************************************************
''Function to update transaction details in excel
'' Added By Shruti Kumthekar
''***********************************************************************************************

Public Function Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel(sExcelPath,sAction,sFunctionality,sActionPerformed,sPerformanceDuration,sActionResult,sScriptResult,sScriptDuration)
	Dim objExcel,objWorkBook,objNewSheet,objWorksheet,objFSO,objRange,objMyRange
	Dim sTCSheetName,sColumnHeader,sAverage
	Dim iRowCount,iColumnCount,iRandNo, iRandNoTestName,sFileName
	Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel=False
	
	Const xlCellTypeLastCell = 11
	Const xlContinuous = 1
	Const xlCenter = -4108
	
	If sExcelPath="" Then
	sFileName=FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","TestScriptBusinessFunctionalityPerformanceDurationFileName","")
		sExcelPath=Environment.Value("Reports")& "\" &sFileName
	End If
	Set objFSO = CreateObject("Scripting.FileSystemObject")	
	If not (objFSO.FileExists(sExcelPath)) Then
		Exit Function
	End If
	Set objFSO =Nothing
	'Creating Excel Application object
	Set objExcel = CreateObject("Excel.Application")
	objExcel.visible=False
	objExcel.AlertBeforeOverwriting=False
	objExcel.DisplayAlerts=False
	'Open file
	Set objWorkBook = objExcel.Workbooks.Open(sExcelPath)	
	
	Set objWorksheet = objWorkbook.Worksheets("Performance Details")
	objWorksheet.Activate
	iRandNoTestName = Fn_Setup_RandNoGenerate(3)
	Select Case sAction
		Case "updateperformancedetails"
			'Creating object of AVERAGE Details sheet
			sTCSheetName=Environment.Value("TestName")
		
			iColumnCount=objWorksheet.UsedRange.columns.Count
		
			sUsedColumnCount = objWorksheet.usedrange.rows.count
			sUsedColumnCount = sUsedColumnCount + 1
			objWorksheet.Range("B" & sUsedColumnCount) = Now()
			objWorksheet.Range("C" & sUsedColumnCount) = Environment.Value("TestName")
			objWorksheet.Range("D" & sUsedColumnCount) = sActionPerformed
			objWorksheet.Range("E" & sUsedColumnCount) = sPerformanceDuration
			objWorksheet.Range("F" & sUsedColumnCount) = sActionResult
			objWorkSheet.Range("F" & sUsedColumnCount).Font.Bold = True
			objWorksheet.Range("G" & sUsedColumnCount) = "NA"
			objWorksheet.Range("H" & sUsedColumnCount) = "NA"
			If sActionResult = GLOBAL_PERFORMANCE_ACTION_PASS Then
				objWorksheet.Range("F" & sUsedColumnCount).Interior.ColorIndex = "35"
			Else
				objWorksheet.Range("F" & sUsedColumnCount).Interior.Color = RGB(255,128,128)
				objWorksheet.Range("E" & sUsedColumnCount) = "0"
			End If
		
			Set objRange = objWorkSheet.UsedRange
			objRange.columns.AutoFit()
			objRange.columns.HorizontalAlignment = xlCenter
			objRange.columns.VerticalAlignment = xlCenter
			objRange.Borders.LineStyle = xlContinuous
			objWorkBook.Save
			objExcel.Quit
			GLOBAL_PERFORM_UPDATE = True
		'------------------------------------------------------------------------------------------------
		Case "updatescriptdetails" 
'			sUsedColumnCount = 2
			sUsedColumnCount = objWorksheet.usedrange.rows.count
'-----------------------------------------------------------------------------------------------------------
			objWorksheet.Range("A" & sUsedColumnCount)  = Environment.Value("TestName")&"_"&iRandNoTestName
			'If sScriptResult <> "" Then
				objWorksheet.Range("G" & sUsedColumnCount) = sScriptResult
				objWorksheet.Range("H" & sUsedColumnCount) = sScriptDuration
				objWorkSheet.Range("G" & sUsedColumnCount).Font.Bold = True
			'End If
			
			If sScriptResult = "PASS" Then
				objWorksheet.Range("G" & sUsedColumnCount).Interior.ColorIndex = "35"
			Else
				objWorksheet.Range("G" & sUsedColumnCount).Interior.Color = RGB(255,128,128)
				objWorksheet.Range("H" & sUsedColumnCount) = "NA"
'				objWorkSheet.Range("G" & sUsedColumnCount).Font.Bold = True
			End If
'-----------------------------------------------------------------------------------------------------------
			Set objRange = objWorkSheet.UsedRange
			objRange.columns.AutoFit()
			objRange.columns.HorizontalAlignment = xlCenter
			objRange.columns.VerticalAlignment = xlCenter
			objRange.Borders.LineStyle = xlContinuous
			objWorkBook.Save
			objWorkBook.Close 
			objExcel.Quit
			Set objRange = Nothing
			Set objWorkSheet=Nothing
			Set objExcel=Nothing			
			wait 2
			
			Case "updateperformancedetailsexcel"
			'Creating object of AVERAGE Details sheet
			sTCSheetName="TC_" & Environment.Value("TestName")		
			iColumnCount=objWorksheet.UsedRange.columns.Count
			sUsedColumnCount = GLOBAL_PERFORMANCE_USED_COLUMN_COUNT
			sUsedColumnCount = sUsedColumnCount + 1
			objWorksheet.Range("A" & sUsedColumnCount) = Environment.Value("TestName")&"_"&iRandNoTestName
			objWorksheet.Range("B" & sUsedColumnCount) = Now()
			objWorksheet.Range("C" & sUsedColumnCount) = Environment.Value("TestName")
			objWorksheet.Range("D" & sUsedColumnCount) = sActionPerformed
			objWorksheet.Range("E" & sUsedColumnCount) = sPerformanceDuration
			objWorksheet.Range("F" & sUsedColumnCount) = sActionResult
			objWorkSheet.Range("F" & sUsedColumnCount).Font.Bold = True
			objWorksheet.Range("G" & sUsedColumnCount) = "NA"
			objWorksheet.Range("H" & sUsedColumnCount) = "NA"
			If sActionResult = GLOBAL_PERFORMANCE_ACTION_PASS Then
				objWorksheet.Range("F" & sUsedColumnCount).Interior.ColorIndex = "35"
			Else
				objWorksheet.Range("F" & sUsedColumnCount).Interior.Color = RGB(255,128,128)
				objWorksheet.Range("E" & sUsedColumnCount) = "0"
			End If
		
			Set objRange = objWorkSheet.UsedRange
			objRange.columns.AutoFit()
			objRange.columns.HorizontalAlignment = xlCenter
			objRange.columns.VerticalAlignment = xlCenter
			objRange.Borders.LineStyle = xlContinuous
			objWorkBook.Save
			objExcel.Quit
			GLOBAL_PERFORM_UPDATE = True
			GLOBAL_PERFORMANCE_USED_COLUMN_COUNT = GLOBAL_PERFORMANCE_USED_COLUMN_COUNT + 1
		'------------------------------------------------------------------------------------------------
		Case "updatescriptdetailsexcel" 
			sUsedColumnCount = GLOBAL_PERFORMANCE_USED_COLUMN_COUNT
'-----------------------------------------------------------------------------------------------------------
			objWorksheet.Range("G" & sUsedColumnCount) = sScriptResult
			objWorksheet.Range("H" & sUsedColumnCount) = sScriptDuration
			objWorkSheet.Range("G" & sUsedColumnCount).Font.Bold = True
			If sScriptResult = "PASS" Then
				objWorksheet.Range("F" & sUsedColumnCount).Interior.ColorIndex = "35"
			Else
				objWorksheet.Range("G" & sUsedColumnCount).Interior.Color = RGB(255,128,128)
				objWorksheet.Range("H" & sUsedColumnCount) = "NA"

			End If
			
			Set objRange = objWorkSheet.UsedRange
			objRange.columns.AutoFit()
			objR'ange.columns.HorizontalAlignment = xlCenter
			objRange.columns.VerticalAlignment = xlCenter
			objRange.Borders.LineStyle = xlContinuous
			objWorkBook.Save
			objExcel.Quit			
			'Call Fn_RunMacro(sExcelPath)
'-----------------------------------------------------------------------------------------------------------
			
			
			
'-------------------------------------------------------------------------------------------------------------			
			
		
	
	End Select
	''Call Fn_WindowsApplications("TerminateAll", "EXCEL.EXE")
	Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel=True
	'Releasing objects
	Set objRange =Nothing
	Set objMyRange =Nothing
	Set objWorksheet =Nothing
	Set objNewSheet=Nothing
	Set objWorkBook =Nothing
	Set objExcel =Nothing
End Function
'******************************************************************************
Public Function Fn_Create_SummarySheet(strFolderLocation)

   Const xlCenter = -4108
   Const xlLeft = -4131
   Const xlUnderlineStyleNone = -4142
   Const xlAutomatic = -4105
   Const xlNone = -4142
   Const xlContinuous = 1
   Const xlThin = 2
   Const xlDiagonalDown = 5
   Const xlDiagonalUp = 6
   Const xlEdgeLeft = 7
   Const xlEdgeTop = 8
   Const xlEdgeBottom = 9
   Const xlEdgeRight = 10
   Const xlInsideVertical = 11 
   Const xl2003=56

   Dim objExcel
   Dim objWorkBook
   Dim objWorkSheet
   Dim objRange
   Dim strExcelPath
   Dim strExcelVersion

	On Error Resume Next

	Set objExcel = CreateObject("Excel.Application")

	If Err.Number = 0 Then

		strExcelVersion = objExcel.Version
		
		Set objWorkBook = objExcel.Workbooks.Add
		
		If Err.Number <> 0 Then
			Fn_Create_SummarySheet = False
			Exit Function
		End If
			
		objExcel.Visible = False
		objExcel.DisplayAlerts = False 
		
		Set objWorkBook = objExcel.Application.ActiveWorkbook
		
		If objWorkbook.Worksheets.Count > 2 Then
			Do While objWorkbook.Worksheets.Count > 2
				objWorkBook.Worksheets(objWorkbook.Worksheets.Count).delete
			Loop
		Elseif objWorkbook.Worksheets.Count < 2 Then
			objExcel.ActiveWorkbook.Worksheets.Add
		End If
		
		Set objWorkSheet = objWorkBook.WorkSheets(1)
		
			objWorkSheet.Name = "Test Details"
		
			objWorkSheet.Cells(1,1).Value = "Sr No."
			objWorkSheet.Cells(1,2).Value = "Test Case"
			'objWorkSheet.Cells(1,3).Value = "Date"   
			objWorkSheet.Cells(1,3).Value = "StartTime"  			 
			objWorkSheet.Cells(1,4).Value = "EndTime"  			 			
			objWorkSheet.Cells(1,5).Value = "Result"    
			objWorkSheet.Cells(1,6).Value = "Comments"    
			objWorkSheet.Cells(1,7).Value = "Logs"
		
			objWorkSheet.Columns(1).ColumnWidth = 10
			objWorkSheet.Columns(2).ColumnWidth = 30
			'objWorkSheet.Columns(3).ColumnWidth = 20
			objWorkSheet.Columns(3).ColumnWidth = 20
			objWorkSheet.Columns(4).ColumnWidth = 20
			objWorkSheet.Columns(5).ColumnWidth = 10
			objWorkSheet.Columns(6).ColumnWidth = 30
			objWorkSheet.Columns(7).ColumnWidth = 70
		
			Set objRange = objWorkSheet.Range("A1:G1")
			objRange.HorizontalAlignment = xlCenter
			objRange.VerticalAlignment = xlCenter 
			objRange.Font.Name = "Arial"
			objRange.Font.Size = "12"
			objRange.Font.Bold = True
			objRange.Interior.ColorIndex = "37"
			objRange.Borders.LineStyle = xlContinuous   
	
		Set objWorkSheet = objWorkBook.WorkSheets(1)
		objWorkSheet.Activate
		Set objRange = objWorkSheet.UsedRange
		objRange.Range("A1").Activate
		
		If Instr(strFolderLocation,".xlsx") Then
			strExcelPath=strFolderLocation
		Else
			strExcelPath = strFolderLocation & "\BatchRunDetails.xlsx"
		End If
		
		
		If strExcelVersion = "12.0" Then
			objWorkBook.SaveAs(strExcelPath), xl2003
		Else
			objWorkBook.SaveAs(strExcelPath)
		End If
		objExcel.Quit
		
		Set objRange = Nothing
		Set objWorkSheet = Nothing
		Set objWorkBook = Nothing
		Set objExcel = Nothing
		
		Fn_Create_SummarySheet = strExcelPath
	Else
		Fn_Create_SummarySheet = False
	End If

End Function
''************************************************************************************
''Function to create new excel monthly for performance transaction details
'************************************************************************************
Public Function Fn_Create_TransactionSummarySheet(strFolderLocation)

   Const xlCenter = -4108
   Const xlLeft = -4131
   Const xlUnderlineStyleNone = -4142
   Const xlAutomatic = -4105
   Const xlNone = -4142
   Const xlContinuous = 1
   Const xlThin = 2
   Const xlDiagonalDown = 5
   Const xlDiagonalUp = 6
   Const xlEdgeLeft = 7
   Const xlEdgeTop = 8
   Const xlEdgeBottom = 9
   Const xlEdgeRight = 10
   Const xlInsideVertical = 11 
   Const xl2003=56

   Dim objExcel
   Dim objWorkBook
   Dim objWorkSheet
   Dim objRange
   Dim strExcelPath
   Dim strExcelVersion

	On Error Resume Next

	Set objExcel = CreateObject("Excel.Application")

	If Err.Number = 0 Then

		strExcelVersion = objExcel.Version
		
		Set objWorkBook = objExcel.Workbooks.Add
		
		If Err.Number <> 0 Then
			Fn_Create_TransactionSummarySheet = False
			Exit Function
		End If
			
		objExcel.Visible = False
		objExcel.DisplayAlerts = False 
		
		Set objWorkBook = objExcel.Application.ActiveWorkbook
		
		If objWorkbook.Worksheets.Count > 2 Then
			Do While objWorkbook.Worksheets.Count > 2
				objWorkBook.Worksheets(objWorkbook.Worksheets.Count).delete
			Loop
		Elseif objWorkbook.Worksheets.Count < 2 Then
			objExcel.ActiveWorkbook.Worksheets.Add
		End If
		
		Set objWorkSheet = objWorkBook.WorkSheets(1)
		
			objWorkSheet.Name = "Performance Details"
		
			objWorkSheet.Cells(1,1).Value = "Unique_ID"
			objWorkSheet.Cells(1,2).Value = "Time Stamp"
			objWorkSheet.Cells(1,3).Value = "Script Name"   
			objWorkSheet.Cells(1,4).Value = "Transaction Name"  			 
			objWorkSheet.Cells(1,5).Value = "Transaction Time"    
			objWorkSheet.Cells(1,6).Value = "Transaction Result"    
			objWorkSheet.Cells(1,7).Value = "Script Result"
			objWorkSheet.Cells(1,8).Value = "Script Duration"
		
			objWorkSheet.Columns(1).ColumnWidth = 20
			objWorkSheet.Columns(2).ColumnWidth = 30
			objWorkSheet.Columns(3).ColumnWidth = 40
			objWorkSheet.Columns(4).ColumnWidth = 40
			objWorkSheet.Columns(5).ColumnWidth = 35
			objWorkSheet.Columns(6).ColumnWidth = 30
			objWorkSheet.Columns(7).ColumnWidth = 30
			objWorkSheet.Columns(8).ColumnWidth = 30
		
			Set objRange = objWorkSheet.Range("A1:H1")
			objRange.HorizontalAlignment = xlCenter
			objRange.VerticalAlignment = xlCenter 
			objRange.Font.Name = "Calibri"
			objRange.Font.Size = "14"
			objRange.Font.Bold = True
			objRange.Interior.ColorIndex = "45"
			objRange.Borders.LineStyle = xlContinuous   
	
		Set objWorkSheet = objWorkBook.WorkSheets(1)
		objWorkSheet.Activate
		Set objRange = objWorkSheet.UsedRange
		objRange.Range("A1").Activate
		
		strExcelPath = strFolderLocation
		
		If strExcelVersion = "12.0" Then
			objWorkBook.SaveAs(strExcelPath), xl2003
		Else
			objWorkBook.SaveAs(strExcelPath)
		End If
		objExcel.Quit
		
		Set objRange = Nothing
		Set objWorkSheet = Nothing
		Set objWorkBook = Nothing
		Set objExcel = Nothing
		
		Fn_Create_TransactionSummarySheet = strExcelPath
	Else
		Fn_Create_TransactionSummarySheet = False
	End If

End Function
''***********************************************************************************
''Function to write details to Windchill System Check Excel
''*************************************************************************************
Public Function Fn_LogUtil_UpdateWindchillSystemCheckDetailsInExcel(sExcelPath,sAction,sScriptResult,sScriptDuration)
	Dim objExcel,objWorkBook,objNewSheet,objWorksheet,objFSO,objRange,objMyRange
	Dim sTCSheetName,sColumnHeader,sAverage
	Dim iRowCount,iColumnCount,iRandNo, iRandNoTestName,sFileName
	Fn_LogUtil_UpdateWindchillSystemCheckDetailsInExcel=False
	
	Const xlCellTypeLastCell = 11
	Const xlContinuous = 1
	Const xlCenter = -4108
	
	If sExcelPath="" Then
		sFileName=FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","WindchillSystemCheckReportFileName","")
		sExcelPath= Environment.Value("AutomationDir") &"\Reports\" &sFileName
	End If
	Set objFSO = CreateObject("Scripting.FileSystemObject")	
	If not (objFSO.FileExists(sExcelPath)) Then
		Exit Function
	End If
	Set objFSO =Nothing
	'Creating Excel Application object
	Set objExcel = CreateObject("Excel.Application")
	objExcel.visible=False
	objExcel.AlertBeforeOverwriting=False
	objExcel.DisplayAlerts=False
	'Open file
	Set objWorkBook = objExcel.Workbooks.Open(sExcelPath)	
	
	Set objWorksheet = objWorkbook.Worksheets("Windchill_Details")
	objWorksheet.Activate
	
	Select Case sAction
		Case "UpdateSystemCheckExcel"
			
			sUsedColumnCount = objWorksheet.usedrange.rows.count
			sUsedColumnCount = sUsedColumnCount + 1
			objWorksheet.Range("A" & sUsedColumnCount)=Date
			objWorksheet.Range("B" & sUsedColumnCount)  =Time
			objWorksheet.Range("C" & sUsedColumnCount)  = Environment.Value("TestName")
			
				objWorksheet.Range("E" & sUsedColumnCount) = sScriptResult
				objWorksheet.Range("F" & sUsedColumnCount) = sScriptDuration
				objWorkSheet.Range("E" & sUsedColumnCount).Font.Bold = True
			
			
			If sScriptResult = "PASS" Then
				objWorksheet.Range("D" & sUsedColumnCount)="Windchill Up"
				objWorksheet.Range("E" & sUsedColumnCount).Interior.ColorIndex = "35"
			Else
				objWorksheet.Range("D" & sUsedColumnCount)="Windchill Down"
				objWorksheet.Range("E" & sUsedColumnCount).Interior.Color = RGB(255,128,128)
			End If
'-----------------------------------------------------------------------------------------------------------
			Set objRange = objWorkSheet.UsedRange
			
			objRange.columns.HorizontalAlignment = xlCenter
			objRange.columns.VerticalAlignment = xlCenter
			objRange.Borders.LineStyle = xlContinuous
			objWorkBook.Save
			objWorkBook.Close 
			objExcel.Quit
			Set objRange = Nothing
			Set objWorkSheet=Nothing
			Set objExcel=Nothing			
			
	End Select
End Function
'---------------------------------------------------------------------------------------------------------------------
''Function For closure log for system check script and updation in excel
''Specific function for TC18_SystemCheckForWindchill
'----------------------------------------------------------------------------------------------------------------------
Public Function Fn_PrintClosureLogExcel()
	Dim TotalTestExecutionTime,sFileName,sExcelPath
	GBL_TEST_EXECUTION_END_TIME=Now()	
	
	TotalTestExecutionTime=datediff("s",GBL_TEST_EXECUTION_START_TIME,GBL_TEST_EXECUTION_END_TIME)
	If TotalTestExecutionTime > 60 Then
		TestExecutionMins=TotalTestExecutionTime/60
		TestExecutionMins=Split(Cstr(TestExecutionMins),".")
		TestExecutionSec=TotalTestExecutionTime-Cint(TestExecutionMins(0))*60
		TestExecutionMins(0)=Cint(TestExecutionMins(0))
		TestExecutionSec=Cint(TestExecutionSec)
	Else
		TestExecutionSec = TotalTestExecutionTime
		TestExecutionMins = Split("0")
	End If
	
	If TestExecutionSec < 0 Then
		TestExecutionSec = TestExecutionSec*(-1)
	End If
	
	Call Fn_LogUtil_UpdateWindchillSystemCheckDetailsInExcel("","UpdateSystemCheckExcel",GBL_SCRIPT_RESULT,TestExecutionMins(0)&"mins"&TestExecutionSec&"secs")
	'Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel(sExcelPath,"UpdateSystemCheckExcel","","","","",GBL_SCRIPT_RESULT, TestExecutionMins(0)&"mins"&TestExecutionSec&"secs")
	
	If GBL_SCRIPT_RESULT="PASS" Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog",vbNewLine,"","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","-----------------------------------------------------------------------------------------------","","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","[" & Cstr(time) & "] - Final - Pass | Test Execution Result: PASS","","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","[" & Cstr(time) & "] - Final - Pass | Test Execution Total Time : [ " & Cstr(TestExecutionMins(0)) & " ] Minute [ " & Cstr(TestExecutionSec) & " ] Seconds","","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("updatelog","-----------------------------------------------------------------------------------------------","","","","","")				
		Call Fn_Update_TestResult("",GBL_SCRIPT_RESULT&":All VP Pass", 1)
	End If
End Function

''*********************************************************************************
'Function to create Windchill  System Check Report excel
'******************************************************************************
Public Function Fn_CreateWindchillSystemCheckReport(strExcelPath)

   Const xlCenter = -4108
   Const xlLeft = -4131
   Const xlUnderlineStyleNone = -4142
   Const xlAutomatic = -4105
   Const xlNone = -4142
   Const xlContinuous = 1
   Const xlThin = 2
   Const xlDiagonalDown = 5
   Const xlDiagonalUp = 6
   Const xlEdgeLeft = 7
   Const xlEdgeTop = 8
   Const xlEdgeBottom = 9
   Const xlEdgeRight = 10
   Const xlInsideVertical = 11 
   Const xl2003=56

   Dim objExcel
   Dim objWorkBook
   Dim objWorkSheet
   Dim objRange
'   Dim strExcelPath
   Dim strExcelVersion

	On Error Resume Next

	Set objExcel = CreateObject("Excel.Application")

	If Err.Number = 0 Then

		strExcelVersion = objExcel.Version
		
		Set objWorkBook = objExcel.Workbooks.Add
		
		If Err.Number <> 0 Then
			Fn_Create_SummarySheet = False
			Exit Function
		End If
			
		objExcel.Visible = False
		objExcel.DisplayAlerts = False 
		
		Set objWorkBook = objExcel.Application.ActiveWorkbook
		
		If objWorkbook.Worksheets.Count > 2 Then
			Do While objWorkbook.Worksheets.Count > 2
				objWorkBook.Worksheets(objWorkbook.Worksheets.Count).delete
			Loop
		Elseif objWorkbook.Worksheets.Count < 2 Then
			objExcel.ActiveWorkbook.Worksheets.Add
		End If
		
		Set objWorkSheet = objWorkBook.WorkSheets(1)
		
			objWorkSheet.Name = "Windchill_Details"
		
			objWorkSheet.Cells(1,1).Value = "Date"
			objWorkSheet.Cells(1,2).Value = "Time"
			objWorkSheet.Cells(1,3).Value = "Testcase Name"   
			objWorkSheet.Cells(1,4).Value = "Windchill Status"  			 
			objWorkSheet.Cells(1,5).Value = "Script Result"    
			objWorkSheet.Cells(1,6).Value = "Script Duration"    
			
		
			objWorkSheet.Columns(1).ColumnWidth = 20
			objWorkSheet.Columns(2).ColumnWidth = 20
			objWorkSheet.Columns(3).ColumnWidth = 50
			objWorkSheet.Columns(4).ColumnWidth = 30
			objWorkSheet.Columns(5).ColumnWidth = 20
			objWorkSheet.Columns(6).ColumnWidth = 20
			objWorkSheet.Columns(7).ColumnWidth = 20
			
			objWorkSheet.Rows(1).RowWidth=20
			Set objRange = objWorkSheet.Range("A1:F1")
			objRange.HorizontalAlignment = xlCenter
			objRange.VerticalAlignment = xlCenter 
			objRange.Font.Name = "Calibri"
			objRange.Font.Size = "11"
			objRange.Font.Bold = True
			objRange.Interior.ColorIndex = "37"
			objRange.Borders.LineStyle = xlContinuous   
	
		Set objWorkSheet = objWorkBook.WorkSheets(1)
		objWorkSheet.Activate
		Set objRange = objWorkSheet.UsedRange
		objRange.Range("A1").Activate
		
		
		
		
			objWorkBook.SaveAs(strExcelPath)
		
		objExcel.Quit
		
		Set objRange = Nothing
		Set objWorkSheet = Nothing
		Set objWorkBook = Nothing
		Set objExcel = Nothing
		
		Fn_CreateWindchillSystemCheckReport = strExcelPath
	Else
		Fn_CreateWindchillSystemCheckReport = False
	End If

End Function
''----------------------------------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------------------------------
' Function Number   	: 18                                                                                
' Function Name     	: Fn_ExcelGetResultDetail(sExcelPath, sActionType, iSheetNumber)
' Function Description  : Returns required data from result sheet
' Function Usage    	: Result = Fn_strUtil_SubField(sExcelPath, sActionType, iSheetNumber)
'							sExcelPath		- Location of Excelsheet
'							sActionType		- 4 types of action supported
'													i. FailExist
'												   ii. NoTestCases
'												  iii. FailCount
'												   iv. PassCount									
'							intSheetNumber	- Excel sheet number
'                     return Sub String on success, False on failuer     
' Function History
'----------------------------------------------------------------------------------------------------------------------
'	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
'----------------------------------------------------------------------------------------------------------------------
' 		|  06-May-2010	| 	1.0	 |									|				|  
'----------------------------------------------------------------------------------------------------------------------

Public Function Fn_ExcelGetResultDetail(sExcelPath, sActionType, iSheetNumber)

	Const xlCellTypeLastCell = 11
	Dim objFSO, objExcel, objWorkbook, objWorkSheet, objRange
	Dim usedRange, iColId , PassCnt, FailCnt, TotalCnt
    
	iColId = Fn_ExcelSearch(sExcelPath, "Result", iSheetNumber)
	iColId = Fn_strUtil_SubField(iColId, ":", 1)    
	
	iColId = Chr(64 + iColId)
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If objFSO.FileExists(sExcelPath) Then
	
		Set objExcel = CreateObject("Excel.Application")
			objExcel.Visible = False
			objExcel.AlertBeforeOverwriting = False
			objExcel.DisplayAlerts = False
	
			Set objWorkbook = objExcel.Workbooks.Open(sExcelPath)	

			If iSheetNumber = "" Then
				 iSheetNumber = 1
			End If 			
			
			Set objWorkSheet = objExcel.ActiveWorkbook.Worksheets(iSheetNumber)
			Set objRange = objWorkSheet.UsedRange
			objRange.SpecialCells(xlCellTypeLastCell).Activate	
			
			usedRange = iColId & "2:" & iColId & objExcel.ActiveCell.Row
			
			if  LCase(sActionType) = LCase("FailExist") Then
				objExcel.Cells(10000, 1).Formula = "=COUNTIF(" & usedRange & "," & Chr(34) & "FAIL" & Chr(34) & ")"
				FailCnt = objExcel.Cells(10000, 1).value
				if  FailCnt > 0 then
					Fn_ExcelGetResultDetail = True
				else
					TotalCnt = objExcel.ActiveCell.Row - 1
					objExcel.Cells(10000, 1).Formula = "=COUNTIF(" & usedRange & "," & Chr(34) & "PASS" & Chr(34) & ")"
					PassCnt = objExcel.Cells(10000, 1).value
					objExcel.Cells(10001, 1).Formula = "=COUNTIF(" & usedRange & "," & Chr(34) & "FAIL" & Chr(34) & ")"
					FailCnt = objExcel.Cells(10001, 1).value
					if  PassCnt + FailCnt <> TotalCnt then
						Fn_ExcelGetResultDetail = True
					else
						Fn_ExcelGetResultDetail = False
					end if
				end if																																			
			elseif LCase(sActionType) = LCase("NoTestCases") Then
				Fn_ExcelGetResultDetail = objExcel.ActiveCell.Row - 1				
				
			elseif LCase(sActionType) = LCase("PassCount") then			
				objExcel.Cells(10000, 1).Formula = "=COUNTIF(" & usedRange & "," & Chr(34) & "PASS" & Chr(34) & ")"
				Fn_ExcelGetResultDetail = objExcel.Cells(10000, 1).value
				
			elseif LCase(sActionType) = LCase("FailCount") then
				TotalCnt = objExcel.ActiveCell.Row - 1
				objExcel.Cells(10000, 1).Formula = "=COUNTIF(" & usedRange & "," & Chr(34) & "PASS" & Chr(34) & ")"
				PassCnt = objExcel.Cells(10000, 1).value
				objExcel.Cells(10001, 1).Formula = "=COUNTIF(" & usedRange & "," & Chr(34) & "FAIL" & Chr(34) & ")"
				FailCnt = objExcel.Cells(10001, 1).value
				if  PassCnt + FailCnt <> TotalCnt then
					Fn_ExcelGetResultDetail = 	TotalCnt - PassCnt
				else
					Fn_ExcelGetResultDetail = 	FailCnt																	      	
				end if								
			end if				
			
							
	objExcel.Quit			
			
    Set objRange = Nothing
    Set objWorkSheet = Nothing
    Set objWorkbook = Nothing
    Set objExcel = Nothing
	Set objFSO = Nothing			
			
	End If	

End Function

'**********************************************************************************************************************
' Function Number   	: 15                                                                                
' Function Name     	: Fn_GetBatchName(BatchFolderPath)
' Function Description  : Return the folder name created runtime
' Function Usage    	: Result = Fn_GetBatchName(BatchFolderPath)
'							BatchFolderPath	- Location of Excel
'             				return Foldername on success, False on failuer
' Function History
'----------------------------------------------------------------------------------------------------------------------
'	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
'----------------------------------------------------------------------------------------------------------------------
' 		|  30-Apr-2010	| 	1.0	 |									|				|
'**********************************************************************************************************************
Public Function Fn_GetBatchName(sFolderPath)

	Dim objFSO
	Dim BatchName

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If objFSO.FolderExists(sFolderPath) Then
		BatchName = objFSO.GetBaseName(sFolderPath)
		Fn_GetBatchName = BatchName
	Else
		Fn_GetBatchName = False
	End If

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
''*******************************************************************
''Fn_SystemCheckEmailBody()
''*******************************************************************
Function Fn_SystemCheckEmailBody()
	Dim sMailBody
	
	sMailBody="<HTML><HEAD></HEAD>" & _
				"<BODY>" & _
				"<p><font face=""Calibri"" SIZE=3>Hello Users,</font></p>" & _
				"<p><font face=""Calibri"" SIZE=3>Windchill has stopped working on "&Environment.Value("LocalHostName")&".Please find the attached snapshot.</font></p>" & _
				"<p><font face=""Calibri"" SIZE=3>Thanks</font></p>" & _
				"<p><font face=""Calibri"" SIZE=3>Automation Team</font>" & _
				"<br><font color=#00AB66><B>SQS</B></font><br></p>" & _
				"<p><font face=""Arial"" SIZE=1><br><br><br>PS: This is a automated mail, please do not reply</p>" & _
				"</BODY></HTML>"
			Fn_SystemCheckEmailBody=sMailBody
End Function

'*********************************************************	Function List		***********************************************************************
'2. Fn_EmailBodyTxt(strExcelPath)
'*********************************************************	Function List		***********************************************************************
Function Fn_EmailBodyHTML(strExcelPath)
	Dim bReturn
	Dim sBatchOwner
	Dim sBatchName
	Dim sBatchResult
	Dim sBatchDate
	Dim sBatchDuration
	Dim sBatchLogFolder
	Dim sBatchTotalTestCases
	Dim sBatchPassTestCases
	Dim sBatchFailTestCases
	Dim sBrowserUsed
	Dim sBatchArea
	Dim sMailBody

	' Batch result
	bReturn = Fn_ExcelGetResultDetail(strExcelPath,"FailExist", 1)
	if bReturn = True Then
		'sBatchResult = "FAIL" 
		sBatchResult = "<tr><td><font face=""Arial"" SIZE=2>Batch Test Result</td>" &_
					   "<td BGCOLOR=""#FF7373"" align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;FAIL</B></td></tr>"
	else
		'sBatchResult = "PASS"
		sBatchResult = "<tr><td><font face=""Arial"" SIZE=2>Batch Test Result</td>" &_
					   "<td BGCOLOR=""#7DDBA9"" align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;PASS</B></td></tr>"
	end if	

	' Batch Name
	sBatchName = Fn_GetBatchName(Environment("BatchResultFolder"))

	' Batch duration
	sBatchDuration = Fn_BatchDuration(strExcelPath)

	' Batch log folder
	sBatchLogFolder = Environment.Value("LocalHostName") & "\" & sBatchName

	' Cleanup batch result 
	'bReturn = Fn_BatchResultCleanup(strExcelPath, 1)

	'
	sBatchArea="MAN Single User Performance Experience"

	' Total testcases in batch
	sBatchTotalTestCases = Fn_ExcelGetResultDetail(strExcelPath, "NoTestCases", 1)

	' Pass test cases in batch
	sBatchPassTestCases = Fn_ExcelGetResultDetail(strExcelPath, "PassCount", 1)

	' Fail test cases in batch
	sBatchFailTestCases = sBatchTotalTestCases - sBatchPassTestCases

	sMailBody = ""
	sMailBody = "<HTML><HEAD></HEAD>" & _
				"<BODY>" & _
				"<table border=1 cellpadding=1 cellspacing=1 bordercolor=""gray"" width=100%>" & _
				"<tr><th colspan=2 bgcolor=""#A0CFEC""><font face=""Arial"" size=4>MAN Automation Test Result</font></th></tr>" & _
				"<tr><th colspan=2 align=""left"" bgcolor=""#A0CFEC""><font face=""Arial"" SIZE=3>Test Details </font></th></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Batch Test Area </font></td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;" & Trim(sBatchArea) & "</B></font></td></tr>" & _
				sBatchResult & _
				"<tr><td><font face=""Arial"" SIZE=2>Total Test Cases in Batch </font></td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;" & sBatchTotalTestCases & "</B></font></td></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Number of Passed Test Cases</font></td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;" & sBatchPassTestCases & "</B></font></td></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Number of Failed Test Cases</td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;" & sBatchFailTestCases & "</B></font></td></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Batch Duration</td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2><B>&nbsp;" & sBatchDuration & "</B></font></td></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Test Logs </font></td><td align=""left"" valign=""center"">" & _
				"<a href=""\\"& sBatchLogFolder &"""><font face=""Arial"" SIZE=2><B>\\"& sBatchLogFolder &"&nbsp;</B></font></a></td></tr>" & _
				"<tr><th colspan=2 align=""left"" bgcolor=""#A0CFEC""><font face=""Arial"" SIZE=3>Batch Details</th></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Batch Date</font></td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2>&nbsp;" & Date & "</font></td></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>Batch Executed By</td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2>&nbsp;" & Environment.Value("BatchExecuter") & "</font></td></tr>" & _
				"<tr><th colspan=2 align=""left"" bgcolor=""#A0CFEC""><font face=""Arial"" SIZE=3>Windchill Details </font></th></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>WindchillVersion</font></td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2>&nbsp;" & Environment("WindchillVersion") & "</font></td></tr>" & _
				"<tr><td><font face=""Arial"" SIZE=2>MAN Host</font></td>" & _
				"<td align=""left"" valign=""center""><font face=""Arial"" SIZE=2>&nbsp;" & Environment("LocalHostName") &"</font></td></tr>" & _
				"</table>" & _
				"<p><font face=""Arial"" SIZE=2>Thanks</font></p>" & _
				"<p><font face=""Arial"" SIZE=2>Automation Team</font>" & _
				"<br><font color=#00AB66><B>SQS</B></font><br></p>" & _
				"<p><font face=""Arial"" SIZE=1><br><br><br>PS: This is a automated mail, please do not reply</p>" & _
				"</BODY></HTML>"

	Fn_EmailBodyHTML = sMailBody

End Function

''--------------------------------------------------------------------------------------------------------------------
'' Function Number   	: 19                                                                                
'' Function Name     	: Fn_BatchDuration(sExcelPath)
'' Function Description  : Returns test duration of the batch run
'' Function Usage    	: Result = Fn_BatchDuration(sExcelPath)
''							sExcelPath		- Location of Excelsheet
''                     return batch test duration on success, False on failuer     
'' Function History
''----------------------------------------------------------------------------------------------------------------------
''	Developer Name		|	  Date		|Rev. No.|		    Changes Done			|	Reviewer	|	Reviewed Date
''----------------------------------------------------------------------------------------------------------------------
'' 		|  06-May-2010	| 	1.0	 |									|				|  
''----------------------------------------------------------------------------------------------------------------------

Function Fn_BatchDuration(sExcelPath)

	Dim objFSO
	Dim objFile
	Dim sfileCreate
	Dim sfileLastModified
	Dim timeDiff
	Dim timeDuration
	Dim timeTaken
	Dim sColumnId
	Dim sTimeSeparator
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")

	If objFSO.FileExists (sExcelPath) Then
		
		Set objFile = objFSO.GetFile(sExcelPath)
		
					
		'sfileCreate = Fn_GetBatchExecutionStartDateAndTime(sExcelPath)
		sfileCreate = objFile.DateCreated
		sfileLastModified = objFile.DateLastModified
		
		timeDiff = Formatnumber((DateDiff("s", sfileCreate, sfileLastModified)/3600), 2, 0, -1)
		
		If instr(1,CStr(timeDiff),",") Then
			sTimeSeparator=","
		Else
			sTimeSeparator="."
		End If
		
		If timeDiff => 1 Then
			Fn_BatchDuration = Fn_strUtil_SubField(timeDiff,sTimeSeparator,0) & " hours, " & Formatnumber((Fn_strUtil_SubField(timeDiff,sTimeSeparator,1) * 0.6), 0, 0, -1) & " mins"
		Else
			Fn_BatchDuration = Formatnumber((Fn_strUtil_SubField(timeDiff,sTimeSeparator,1) * 0.6), 0, 0, -1) & " mins"
		End If
	Else
		Fn_BatchDuration = False
	End if

	Set objFSO = nothing
	Set objFile = nothing

End Function
'--------------------------------------------------------------------------------------------------------------------
'Fn_GetBatchExecutionStartDateAndTime
'--------------------------------------------------------------------------------------------------------------------
Function Fn_GetBatchExecutionStartDateAndTime(sExcelPath)
	Fn_GetBatchExecutionStartDateAndTime=False
	
	Const xlCellTypeLastCell = 11
	Dim objFSO
	Dim objExcel
	Dim objWorkbook
	Dim objWorkSheet
	Dim objRange
	Dim sColumnId
	Dim sStartTime
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If objFSO.FileExists (sExcelPath) Then
		Set objExcel = CreateObject("Excel.Application")
		objExcel.Visible = False
		objExcel.AlertBeforeOverwriting = False
		objExcel.DisplayAlerts = False
			
		Set objWorkbook = objExcel.Workbooks.Open(sExcelPath)
		Set objWorkSheet = objExcel.ActiveWorkbook.Worksheets(1)
		Set objRange = objWorkSheet.UsedRange
		objRange.SpecialCells(xlCellTypeLastCell).Activate
		
		sColumnId = Fn_ExcelSearch(sExcelPath, "Date", iSheetNumber)
		sColumnId = CInt(Fn_strUtil_SubField(sColumnId, "-", 1))
		sStartTime=objWorkSheet.Cells(2,sColumnId).Value
		'sStartTime=Replace(sStartTime,"st- ","")
		sStartTime=sStartTime
		
		Fn_GetBatchExecutionStartDateAndTime=sStartTime
		
		Set objRange = Nothing
		Set objWorkSheet = Nothing
		Set objWorkbook = Nothing
		
		objExcel.Quit
		
		Set objExcel =Nothing
	End If
	Set objFSO =Nothing
End Function
