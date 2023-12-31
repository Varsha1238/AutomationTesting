''*******************************************************************************
''Function initial set up of testcase and creation of log file
''*******************************************************************************

Public Function Fn_Setup_TestcaseInit()

ReDim TestData(8)
Dim strResultSheetLocation,strExcelPath
	
	 Environment.Value("AutomationDir") = Fn_GetEnvValue("User", "AutomationDir")
	 Call LoadEnvXML()
	Reporter.ReportEvent micDone, "Start of Testcase"," Start of  testcase " & Environment.Value("TestName")
	GBL_TEST_EXECUTION_START_TIME = Now()
	Call Fn_LogUtil_CreateTestCaseLogFile(Environment.Value("TestName") & ".log")
	Call Fn_LogUtil_PrintTestCaseHeaderLog()
		
	TestData(1) =  Environment.Value("TestName")
	TestData(2) = Date & " - " & Time
	TestData(3) =GBL_TEST_EXECUTION_START_TIME
	If lcase(Environment.Value("BatchScheduler"))="true" Then
		'Monthly Excel
		sReportFile=FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","BatchSchedulerReportFileName","")
		bResult=Fn_CheckMonthlyReportFileExists(sReportFile)
		If bResult=False Then
			''call fun to create new excel
			sFilename=Split(sReportFile,"_")
			sReportFile=sFilename(0)&"_"&MonthName(Month(Now()),False)
			strExcelPath =  Fn_Create_SummarySheet(Environment.Value("AutomationDir")& "\Reports\"&sReportFile&".xlsx")
		    	Result= Fn_UpdateEnvXMLNode(Environment.Value("AutomationDir")& "\AutomationXml\EnvironmentVariables.XML", "BatchSchedulerReportFileName",sReportFile&".xlsx")		
		End If
		strResultSheetLocation=Environment.Value("Reports") &"\"&Environment.Value("BatchSchedulerReportFileName")
		Call Fn_Update_TestDetail(strResultSheetLocation, TestData, 1)
	End If
	
	'Monthly Transaction Excel
		sReportFile=FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","TestScriptBusinessFunctionalityPerformanceDurationFileName","")
		bResult=Fn_CheckMonthlyReportFileExists(sReportFile)
		If bResult=False Then
			''call fun to create new excel
			sFilename=Split(sReportFile,"_")
			sReportFile=sFilename(0)&"_"&MonthName(Month(Now()),False)
			strExcelPath =  Fn_Create_TransactionSummarySheet(Environment.Value("AutomationDir")& "\Reports\"&sReportFile&".xlsx")
		    	Result= Fn_UpdateEnvXMLNode(Environment.Value("AutomationDir")& "\AutomationXml\EnvironmentVariables.XML", "TestScriptBusinessFunctionalityPerformanceDurationFileName",sReportFile&".xlsx")		
		End If
	
	Call Fn_Update_TestDetail("", TestData, 1)
	Datatable.AddSheet("EnvironmentValues")
	Environment.Value("StepLog") =  "true"
	
	Call Fn_KillProcess("iexplore.exe:EXCEL.EXE*32")
	
End Function
 ''*******************************************************************************
''Init function for system Check Testcase (TC18_SystemCheckForWindchill)
''*******************************************************************************
Public Function Fn_Setup_TestInit()

'ReDim TestData(8)
Dim ReportsFolder,Result,sReportFile,bResult,sFilename
	
	 Environment.Value("AutomationDir") = Fn_GetEnvValue("User", "AutomationDir")
	 Call LoadEnvXML()
	Reporter.ReportEvent micDone, "Start of Testcase"," Start of  testcase " & Environment.Value("TestName")
	
	ReportsFolder = Fn_Create_Folder(Environment.Value("AutomationDir")&"\Reports\WindchillSystemCheck_Reports\" & Date)
	Result= Fn_UpdateEnvXMLNode(Environment.Value("AutomationDir")& "\AutomationXml\EnvironmentVariables.XML", "SystemCheckReports", ReportsFolder)		
	
	GBL_TEST_EXECUTION_START_TIME = Now()
	Environment.Value("TestLogFileName")=Environment.Value("TestName")&Hour(Now)&"-"&Minute(Now)
	Call Fn_LogUtil_CreateTestLogFile(ReportsFolder,Environment.Value("TestLogFileName")& ".log")
	Call Fn_LogUtil_PrintTestCaseHeaderLog()
	
	''Monthly Excel
	sReportFile=FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","WindchillSystemCheckReportFileName","")
	bResult=Fn_CheckMonthlyReportFileExists(sReportFile)
	If bResult=False Then
		''call fun to create new excel
		sFilename=Split(sReportFile,"_")
		sReportFile=sFilename(0)&"_"&MonthName(Month(Now()),False)
		Call Fn_CreateWindchillSystemCheckReport(Environment.Value("AutomationDir")& "\Reports\"&sReportFile&".xlsx")
	    	Result= Fn_UpdateEnvXMLNode(Environment.Value("AutomationDir")& "\AutomationXml\EnvironmentVariables.XML", "WindchillSystemCheckReportFileName",sReportFile&".xlsx")		
	End If
	Datatable.AddSheet("EnvironmentValues")
	Environment.Value("StepLog") =  "true"
	
	Call Fn_KillProcess("iexplore.exe:EXCEL.EXE*32")
End Function

Public Function Fn_CheckMonthlyReportFileExists(sReportFile)

Dim oTempFile, oFileCollection, strTemp, oFSO, oFolder
  Set oFSO = CreateObject("Scripting.FileSystemObject")
  
 Set oFolder = oFSO.GetFolder(Environment.Value("AutomationDir")&"\Reports")
 Set oFileCollection = oFolder.Files
 For Each oTempFile in oFileCollection
  If LCase(oFSO.GetExtensionName(oTempFile.Name))="xlsx" Then
  	If oTempFile.name = sReportFile Then
 		
 		If Instr(oTempFile.name ,MonthName(Month(Now())))Then
 			Fn_CheckMonthlyReportFileExists=True
 			Exit For
 		End If
 	End If
 Fn_CheckMonthlyReportFileExists=False
 End If 
    Next
   
End Function
  ''*******************************************************************************
''Function to generate random number
''*******************************************************************************
 Public Function Fn_Setup_RandNoGenerate(iLength)
	Dim iNumber,iStartNumber,iCount
    Randomize
	iStartNumber="9"
	For iCount=1 To iLength-1
		iStartNumber=Cstr(iStartNumber)+"0"
	Next
	 iNumber = Int((iStartNumber * Rnd) + 1)
	 If Len(Cstr(iNumber)) < iLength Then
			Fn_Setup_RandNoGenerate = "0" + Cstr(iNumber)
	 Else
			Fn_Setup_RandNoGenerate = Cstr(iNumber)
	 End If
End Function

'******************************************************************************
''Function to kill processes
''******************************************************************************
Public Function Fn_KillProcess(sProcessToKill)
			Dim sArrData,  iCount, strComputer,sImgPath
			Dim objWMIService, objProcess, colProcess
			Dim sSOAUser
			Dim aPrefName
			Dim aPrefVal
			Dim aPrefScope
			Dim objTcWin_1, iWinCnt_1, i_1, sWinTitle
			Dim bReturn
										
			   If  sProcessToKill = "" Then
						sProcessToKill = Environment.Value("KillProcesses")                        
				End If
				
				sArrData = split(sProcessToKill, ":",-1,1)

				strComputer = "." 
				Set objWMIService = GetObject("winmgmts:"& "{impersonationLevel=impersonate}!\\"& strComputer & "\root\cimv2") 

				For iCount = 0 to ubound(sArrData)
					Set colProcess = objWMIService.ExecQuery("Select * from Win32_Process Where Name ='"+sArrData(iCount)+"'")  
					'For Each objProcess in colProcess 
					For Each objProcess in colProcess 
							objProcess.Terminate() 
					Next 
				Next

				Set objWMIService = Nothing
				Set colProcess = Nothing

				If Err.Number <> 0 Then
					Fn_KillProcess =False
				Else
					Fn_KillProcess =True
				End If

End Function
''*************************************************
''Exit test and kill processes
'*************************************************
Function Fn_ExitFromTest()
Call Fn_KillProcess("iexplore.exe:EXCEL.EXE*32")
	ExitTest
End Function
