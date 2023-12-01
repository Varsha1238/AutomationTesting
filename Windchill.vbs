''*******************************************************************************
''Function to Login to windchill
''*******************************************************************************
Function LoginToWindChill(sUserName,sPassword, sURL)
	Dim sUser
	err.clear
	'until no more browsers exist
	While Browser("creationtime:=0").Exist(0)
		'Close the browser
		Browser("creationtime:=0").Close
	Wend
 	
 	SystemUtil.CloseProcessByName("iexplorer.exe")
 	
	If sURL="" Then	
		sURL=FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","WindchillUrl","")
	End If
	
	If sUserName="" AND sPassword="" Then
		'Get Windchill test creadentials 
		sUser = FSOUtil_XMLFileOperations("getvalue","EnvironmentVariables","WindchillTestUser","")
		If sUser<>False Then
			sUserName=Split(sUser,":")(0)
			sPassword=Split(sUser,":")(1)
		End If
	End If
	
	blnRet = SystemUtil.Run ("iexplore",sURL)
	
	If 	Browser("Start_Browser").Dialog("Login_Window").Exist(5) Then
		Browser("Start_Browser").Dialog("Login_Window").WinEdit("User_Name").Set sUserName
		Browser("Start_Browser").Dialog("Login_Window").WinEdit("Password").Set sPassword
		'Browser("Start_Browser").Dialog("Login_Window").WinEdit("Password").SetSecure sPassword
		Browser("Start_Browser").Dialog("Login_Window").WinButton("OK").Click	
	End If	
	
	If 	Browser("Start_Browser").Page("Windchill_Getstarted").Exist(20) Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully login to Windchill application using "& sUsername,"","","","","")
		Window("hwnd:=" & Cstr(Browser("Start_Browser").Object.HWND)).Activate
		Window("hwnd:=" & Cstr(Browser("Start_Browser").Object.HWND)).Maximize
	Else
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to login to Windchill application using "& sUsername,"","","","","")
		Call Fn_ExitFromTest()
	End If
	
 End Function

 ''*******************************************************************************
''Function toNavigateTree
''*******************************************************************************
Function NavigateTreeOperation(sAction, sInvokeOption, sTreeNode)
	Err.clear
	Dim aTreeNode, iCounter,jCounter, objNodeTable
	NavigateTreeOperation=false
	
	Select Case sInvokeOption
		Case "Durchsuchen", "durchsuchen", "foldersearch", "FolderSearch"
			Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Durchsuchen").Click 5,5,micLeftBtn
		Case "Search", "search", "Suchen", "suchen"
			Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Suchen").Click 5,5,micLeftBtn
	End Select
	
 	Select Case lcase(sAction)
 		Case "select"
 			Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_NavTreeNode").SetTOProperty "text", sTreeNode
 			If Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_NavTreeNode").exist(10) then
 				Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_NavTreeNode").Click
 				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected node [" & sTreeNode & "]","","","","","")
 				wait 1
 			Else
 				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select node [" & sTreeNode & "]","","","","","")
				Call Fn_ExitFromTest()
 			End If 
 			
 		Case "expand"	
 			Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("TreeNode").SetTOProperty "innertext", sTreeNode
 			If Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("TreeNode").exist(5) then
 				If Browser("Start_Browser").Page("Windchill_Getstarted").Image("ExpandButton").Exist(5) Then
 					Browser("Start_Browser").Page("Windchill_Getstarted").Image("ExpandButton").Click
 					wait 1
 				Else
 					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to expand node [" & sTreeNode & "] as expand button is not displayed","","","","","")
					Call Fn_ExitFromTest()
 				End If
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to expand node [" & sTreeNode & "] as node is not displayed in application","","","","","")
				Call Fn_ExitFromTest()			
 			End If 
 			
		Case "expandandselect"
			Set objNodeTable=Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("NavigationPane").WebTable("NodeTable")
			
			aTreeNode=Split(sTreeNode,"~")
			For jCounter=0  To Ubound(aTreeNode)
	
				For iCounter = 1 To 100
					objNodeTable.SetTOProperty "xpath","//DIV[@id=""folderbrowser_tree""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iCounter&"]/TABLE[1]"
'					If iCounter=9 Then
'						wait 1
'					End If
					If objNodeTable.Exist(2) Then
							If Trim(objNodeTable.Link("NodeName").GetROProperty("innertext"))=Trim(aTreeNode(jCounter)) Then
								If objNodeTable.WebElement("Expand").Exist(1) Then
									objNodeTable.WebElement("Expand").Click
									wait 1
								ElseIf  objNodeTable.WebElement("Collapse").Exist(1)  Then
								Else
									objNodeTable.Link("NodeName").highlight
									objNodeTable.Link("NodeName").Click
								End If
								Exit For
							End If
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to expand node [" & sTreeNode & "] as node is not displayed in application","","","","","")
						Call Fn_ExitFromTest()
					End If
				Next
				If jCounter=Ubound(aTreeNode) Then
					NavigateTreeOperation=True
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected node [" & sTreeNode & "]","","","","","")
				End If

			Next

			Set objNodeTable = Nothing
		Case "selectallintermediateintreeandfinalnodeintable"
			aTreeNode = Split(sTreeNode, "~")
			For iCounter = 0 to Ubound(aTreeNode) - 1
				Call NavigateTreeOperation("Select", "", aTreeNode(iCounter))
			Next
			'Call NavigateTreeOperation("Select", "", aTreeNode(Ubound(aTreeNode)))
		Case "navigateandselectfromtable"
			If InStr(sTreeNode,"Konstruktion Elektrik_Elektronik~")>0 Then
				sTreeNode=Replace(sTreeNode,"Konstruktion Elektrik_Elektronik~","")
				Browser("Start_Browser").Page("Windchill_Getstarted").Link("KonstruktionElektrik_Elektron").Highlight
				Browser("Start_Browser").Page("Windchill_Getstarted").Link("KonstruktionElektrik_Elektron").Click
			End If
			sTreeNode=Split(sTreeNode,"~")
'			bResult = NavigateTreeOperation("select", "",sTreeNode(iNode))
			For iNode = 0 To UBound(sTreeNode)
			
				bRowFound=False
				bNodeFound=False
				iRow=1
				
				Do 
					Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("TableRow").SetTOProperty "xpath","//DIV[@id=""folderbrowser_PDM""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iRow&"]/TABLE[1]"
					
					bRowFound = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("TableRow").Exist
					If  bRowFound Then
						If Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("TableRow").Link("NodeLink").GetROProperty("innertext") = sTreeNode(iNode) Then
							Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("TableRow").Link("NodeLink").Highlight
							Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("TableRow").Link("NodeLink").Click
							Browser("Start_Browser").Sync
							bNodeFound=True
							Exit Do
						End If
					End If
					iRow=iRow+1
				Loop While(bRowFound)
			
				If bNodeFound=True Then
					'
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select node [" & sTreeNode(iNode) & "]","","","","","")
				End If
			Next
 	End Select
 End Function 
 ''*******************************************************************************
''Function for Action Menu Operation
''*******************************************************************************
Function ActionMenuOpertion(sAction, sMenuPath)
	Dim iCounter,bFLag, aMenuPath
	err.clear
	bFlag =false
	Select Case lcase(sAction)
		Case "select"
			Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenu").highlight
			Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenu").Click
 			Browser("Start_Browser").Sync
 			aMenuPath = Split(sMenuPath,"~")
	 		For iCounter = 0 To uBound(aMenuPath) Step 1
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").SetTOProperty "text", aMenuPath(iCounter)
	 			  Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").highlight
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").Click 5, 5,micLeftBtn
	 			 bFlag = true
	 		Next
	 		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu [" & sMenuPath & "]","","","","","")
	 	Case "checkout"
	 		sMenuPath = FSOUtil_XMLFileOperations("getvalue","Windchill_Menu","ActionCheckout","")
	 		Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenu").Click
 			Browser("Start_Browser").Sync
 			aMenuPath = Split(sMenuPath,"~")
	 		For iCounter = 0 To uBound(aMenuPath) Step 1
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").SetTOProperty "text", aMenuPath(iCounter)
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").highlight
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").Click 5, 5,micLeftBtn
	 			 bFlag = true
	 		Next
	 		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu [" & sMenuPath & "]","","","","","")
	 		
	 		If Browser("Start_Browser").Page("Windchill_Getstarted").Image("CheckedOut").Exist Then
	 			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified that drawing is checked-out as [Check out ] image is displayed","","","","","")
	 		Else
	 			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to check out as [Check out ] image is not displayed","","","","","")
	 		End If
	 	Case "checkin"
	 		sMenuPath = FSOUtil_XMLFileOperations("getvalue","Windchill_Menu","ActionCheckin","")
	 		Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenu").Click
 			Browser("Start_Browser").Sync
 			aMenuPath = Split(sMenuPath,"~")
	 		For iCounter = 0 To uBound(aMenuPath) Step 1
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").SetTOProperty "text", aMenuPath(iCounter)
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").highlight
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").Click 5, 5,micLeftBtn
	 			 bFlag = true
	 		Next
	 		If Browser("Browser").Page("Page").Exist(2) Then
                            	Browser("Browser").Page("Page").WebEdit("weedt_checkinComments").highlight
                            	Browser("Browser").Page("Page").WebEdit("weedt_checkinComments").Set "Checked"
                           End If
                           Browser("Browser").Page("Page").WebElement("weelm_OK").highlight
	 		Browser("Browser").Page("Page").WebElement("weelm_OK").Click
	 		GBL_FUNCTION_EXECUTION_START_TIME=timer
	 		GLOBAL_PERFORMANCE_ACTION="Time for DPC to checkin "
	 		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu [" & sMenuPath & "]","","","","","")
	 		
	 		GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",Browser("Browser").Page("Page"),"WebEdit","weedt_checkinComments","","","60")	
		
		''Performance Time Calculation
		GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
		If Err.Number < 0 Then
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","ActionMenuOpertion",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			ActionMenuOpertion = False
			Call Fn_ExitFromTest()
		Else
			ActionMenuOpertion = True
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","ActionMenuOpertion",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
		End If
	 	'Case to select Action above the table
		Case "selectext"
			Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenuAboveTable").Click
 			Browser("Start_Browser").Sync
 			aMenuPath = Split(sMenuPath,"~")
	 		For iCounter = 0 To uBound(aMenuPath) Step 1
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").SetTOProperty "text", aMenuPath(iCounter)
	 			 Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").Click 5, 5,micLeftBtn
	 			 bFlag = true
	 		Next
	 		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu [" & sMenuPath & "]","","","","","")
 	End Select
 	If 	bFlag =true then
		ActionMenuOpertion = true
	else
		ActionMenuOpertion = false
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select menu ["&sMenuPath&"]","","","","","")
	end if
 End Function
 ''*******************************************************************************
''Function to Create Document in windchill
''*******************************************************************************
Function CreateDoument(sAction,sProductType, sName, sHauptinhaltsquelle)
	Dim sProjectName
	
	if not Browser("Neues Dokument").Page("Neues Dokument").exist(5) then
		'sMenuPath = FSOUtil_XMLFileOperations("getvalue","Windchill_Menu","ActionNewDocument","")
		Call ActionMenuOpertion("selectext", "Neu~Neues Dokument")
	End If
	
 	Wait 1
 	Err.clear
 	Select Case lcase(sAction)
 		case "create"
 			'Enter product type
 			If sProductType<>"" Then
 				Browser("Neues Dokument").Page("Neues Dokument").WebList("ProductType").Select sProductType
 				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [ProductType] value as [" & sProductType & "]","","","","","")
 			End If 			
 			wait 4
 			If sHauptinhaltsquelle<>"" Then
				Browser("Neues Dokument").Page("Neues Dokument").WebList("primary0contentSourceList").Select sHauptinhaltsquelle
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected [" & sHauptinhaltsquelle & "] in [Hauptinhaltsquelle] drop down ","","","","","")
 			End If
 			If sName<>"" Then
				Browser("Neues Dokument").Page("Neues Dokument").WebEdit("Name").Set sName
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [Name] value as [" & sName & "]","","","","","")
 			End If
 			Browser("Neues Dokument").Page("Neues Dokument").WebButton("Fertigstellen").Highlight
 			Browser("Neues Dokument").Page("Neues Dokument").WebButton("Fertigstellen").Click
 			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on [Fertigstellen] button","","","","","")
 			wait 4
 			
 			
 			If Browser("Start_Browser").Page("Windchill_Getstarted").Link("ProjectName").Exist(5) Then
 				sProjectName=Browser("Start_Browser").Page("Windchill_Getstarted").Link("ProjectName").GetROProperty("text")
 				sProjectName=Split(sProjectName,",")(0)
 				sProjectName=Split(sProjectName,"- ")(1)
 				Call Fn_CommonUtil_DataTableOperations("AddColumn","FunctionReturnValue","","")
 				Datatable.Value("FunctionReturnValue", "Global") =sProjectName
 				
 				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully fetched project name ["& sProjectName &"]","","","","","")
 			Else
 				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to fetch newly created project name","","","","","")
 			End If
 			

 			If err.number=0 then
				CreateDoument = true
			else
				CreateDoument = false
			end if
 	End Select
 End Function
 ''*******************************************************************************
''Function to Close windchill Application
''*******************************************************************************
'Function Fn_CloseWindChillApplication()
'	'until no more browsers exist
'	While Browser("creationtime:=0").Exist(2)
'	'Close the browser
'	Browser("creationtime:=0").Close
'	Wend
'	'SystemUtil.CloseProcessByName("iexplorer.exe")
'	If err.number=0 Then
'		Reporter.ReportEvent micPass, "Close WindChill Application", "successfully Closed WindChill Application"
'	else
'		Reporter.ReportEvent micFail, "Close WindChill Application", "failed to Close WindChill Application"
'	end if
'End Function

Public Function Fn_FolderTransferProcessOperations(sAction, sSourceFolderPath, sDestinationFolderPath, sInputFolderNames)
	Dim iCounter, aFolderNames
	Select Case sAction
		Case "ExportDrawings"
			IF sSourceFolderPath = "" or sDestinationFolderPath = "" or sInputFolderNames = "" Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to perform action [" & sAction & "] as one of the following parameters was blank: SourceFolderPath [" & sSourceFolderPath & "] DestinationFolderPath [" & sDestinationFolderPath & "] InputFolderNames [" & sInputFolderNames & "]","","","","","")
				Call Fn_ExitFromTest()	
			End If
			
			aFolderNames = Split(sInputFolderNames, "~")
			For iCounter = 0 to Ubound(aFolderNames)
'				If Fn_FSOUtil_FolderOperations("Create",sDestinationFolderPath & "\" & aFolderNames(iCounter),,"","") = False Then
'					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed create folder [" & sDestinationFolderPath & "\" & aFolderNames(iCounter) & "]","","","","","")
'					Call Fn_ExitFromTest()	
'				End IF
				
				If Fn_FSOUtil_FolderOperations("copy",sSourceFolderPath & "\" & aFolderNames(iCounter),sDestinationFolderPath & "\" & aFolderNames(iCounter),"","") = False Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed copy folder [" & sSourceFolderPath & "\" & aFolderNames(iCounter) & "] and paste in DestinationFolderPath [" & sDestinationFolderPath & "]","","","","","")
					Call Fn_ExitFromTest()	
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully copied folder [" & sSourceFolderPath & "\" & aFolderNames(iCounter) & "] and paste in DestinationFolderPath [" & sDestinationFolderPath & "]","","","","","")
				End IF
				
				If Fn_FSOUtil_FolderOperations("copy",sSourceFolderPath & "\" & aFolderNames(iCounter),sDestinationFolderPath & "\" & aFolderNames(iCounter),"","") = False Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed copy folder [" & sSourceFolderPath & "\" & aFolderNames(iCounter) & "] and paste in DestinationFolderPath [" & sDestinationFolderPath & "]","","","","","")
					Call Fn_ExitFromTest()	
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully copied folder [" & sSourceFolderPath & "\" & aFolderNames(iCounter) & "] and paste in DestinationFolderPath [" & sDestinationFolderPath & "]","","","","","")
				End IF
				
				'Rename folder
				sDate=CStr(now())
				sDate=Replace(sDate,".","-")
				sDate=Replace(sDate,":","-")
				sDate=Replace(sDate," ","_")
				sNewFolderName=Replace(aFolderNames(iCounter),"RDY",sDate)
				
				If Fn_FSOUtil_FolderOperations("rename",sSourceFolderPath & "\" & aFolderNames(iCounter),sSourceFolderPath & "\" & sNewFolderName,"","")=False Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to rename folder [" & sSourceFolderPath & "\" & aFolderNames(iCounter) & "] to [" & sNewFolderName & "]","","","","","")
					Call Fn_ExitFromTest()	
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully renamed folder [" & sSourceFolderPath & "\" & aFolderNames(iCounter) & "] to [" & sNewFolderName & "]","","","","","")
				End IF
			Next
			
			GBL_EXPORT_FOLDER_OPERATION_TIME = Now()
			For iCounter = 0 to Ubound(aFolderNames)
				IF Fn_FSOUtil_FolderOperations("nonexistforspecifiedtime",sDestinationFolderPath & "\" & aFolderNames(iCounter),"","900","") = False Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed as folder [" & sDestinationFolderPath & "\" & aFolderNames(iCounter) & "] is present after waiting for 900 seconds","","","","","")
					Call Fn_ExitFromTest()	
				Else
					If iCounter = 0 Then
						GBL_EXPORT_FOLDER_OPERATION_TIME = DateDiff("s",GBL_EXPORT_FOLDER_OPERATION_TIME, Now())
					End If
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified that folder [" & sDestinationFolderPath & "\" & aFolderNames(iCounter) & "] is not present in destination folder. Time required for this operation is [" & GBL_EXPORT_FOLDER_OPERATION_TIME & "] seconds","","","","","")
				End If
			Next
			
		Case "GetMANNumber"
			Call Fn_CommonUtil_DataTableOperations("AddColumn","FunctionReturnValue","","")
			aFolderNames = Split(sInputFolderNames, "~")
			Datatable.SetCurrentRow 1
			For iCounter = 0 to Ubound(aFolderNames)
				If iCounter = 0 Then
					Datatable.Value("FunctionReturnValue", "Global") = Split(aFolderNames(iCounter),"_")(0)
				Else	
					Datatable.Value("FunctionReturnValue", "Global") = Datatable.Value("FunctionReturnValue", "Global") & "~" & Split(aFolderNames(iCounter),"_")(0)
				End If
			Next
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully retrieved MAN Number as [" & Datatable.Value("FunctionReturnValue", "Global")  & "]","","","","","")
			
		Case "GetChangeNumberFromMANNumber"
			Call Fn_CommonUtil_DataTableOperations("AddColumn","FunctionReturnValue","","")
			aFolderNames = Split(sInputFolderNames, "~")
			Datatable.SetCurrentRow 1
			For iCounter = 0 to Ubound(aFolderNames)
				sMANNumber = Split(aFolderNames(iCounter),"_")(0)
				
				If iCounter = 0 Then
					Datatable.Value("FunctionReturnValue", "Global") = "00.0"& Split(sMANNumber,"-")(1) & ".0"
				Else	
					Datatable.Value("FunctionReturnValue", "Global") = Datatable.Value("FunctionReturnValue", "Global") & "~" & "00.0"& Split(sMANNumber,"-")(1) & ".0"
				End If
			Next
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully retrieved Change Number as [" & Datatable.Value("FunctionReturnValue", "Global")  & "]","","","","","")
			
		Case "GetChangeNumber"
			Call Fn_CommonUtil_DataTableOperations("AddColumn","FunctionReturnValue","","")
			aFolderNames = Split(sInputFolderNames, "~")
			Datatable.SetCurrentRow 1
			
			For iCounter = 0 to Ubound(aFolderNames)
			
				sTempFileName = Fn_FSOUtil_FileOperations("fileexistinstr",sSourceFolderPath & "\" & aFolderNames(iCounter),"",".hed")
				
				Set objFSO = CreateObject("Scripting.FileSystemObject")
				sFilePath = sSourceFolderPath & "\" & aFolderNames(iCounter) & "\" & sTempFileName
				If objFSO.FileExists(sFilePath) Then
					Set objFile = objFSO.OpenTextFile(sFilePath, 1, True )
					sTextLine = ""
					'Get all text file content in variable 
					Do While objFile.AtEndOfStream <> True
						sTextLine = objFile.ReadLine
						If Instr(sTextLine, "MN_AENR") Then
							If iCounter = 0 Then
								Datatable.Value("FunctionReturnValue", "Global") = Trim(Split(sTextLine, """")(1))
							Else
								Datatable.Value("FunctionReturnValue", "Global") = Datatable.Value("FunctionReturnValue", "Global") & "~" & Trim(Split(sTextLine, """")(1))
							End If
							
						End If
					Loop
				End If
			Next
			
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully retrieved Change Number as [" & Datatable.Value("FunctionReturnValue", "Global")  & "]","","","","","")
			Set objFSO = Nothing
			Set objFile = Nothing

	End Select
End Function
''*******************************************************************************
''Function to Search  in Windchill (Durucsuchen Tab)
''*******************************************************************************
Public Function Fn_SearchInWindChill(dicSearchParameters)
	
	Fn_SearchInWindChill=False
	Dim objWebElm,objLink,objTable,objWebEdit,objImage,ResultTable
	
Set objWebElm=Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("weelm_Library")
Set objLink=Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_AllLibraries")
Set objTable=Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_LibarySearch")
Set objWebEdit=Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_LibarySearch").WebEdit("weedt_LibraryName")
Set objImage=Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_LibarySearch").Image("LibSearchImage")
	
If dicSearchParameters("ObjectType") <> "" Then
	Select Case dicSearchParameters("ObjectType")
		Case "Library"
			ResultTable=	"LibrarySearchResultsTable"
		Case "Product"
			ResultTable= "ProductSearchResultsTable"
			objWebElm.SetTOProperty "xpath","//LI[@id='object_main_navigation__productNavigation']/A[2]/EM[1]/SPAN[1]/SPAN[1]"
			objLink.SetTOProperty "xpath","//DIV[@id='productNavigation']/DIV[1]/DIV[1]/A[1]"
			objTable.SetTOProperty "xpath","//DIV[@id='netmarkets.product.list.toolBar']/TABLE[1]/TBODY[1]/TR[1]/TD[2]/TABLE[1]/TBODY[1]/TR[1]/TD[1]/TABLE[1]"
			objWebEdit.SetTOProperty "xpath","//INPUT[@id='netmarkets.product.list.searchInListTextBox']"
			objImage.SetTOProperty "xpath","//DIV[@id='netmarkets.product.list.toolBar']/TABLE[1]/TBODY[1]/TR[1]/TD[2]/TABLE[1]/TBODY[1]/TR[1]/TD[1]/TABLE[1]/TBODY[1]/TR[1]/TD[3]/DIV[1]/SPAN[1]/IMG[2]"
	End Select
		
End If
	''Click on Durusuchen link
	Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Durchsuchen").Click
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Durchsuchen link","","","","","")
	
	''Icon Click
	objWebElm.Click
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on object icon","","","","","")
	
	''Click on Show All
	objLink.Click
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on  show all link.","","","","","")
	
	If objTable.Exist(2) Then
		objWebEdit.highlight
		objWebEdit.Set dicSearchParameters("ObjectName")
		wait 1
		objImage.Click
		Browser("Start_Browser").Sync
		wait 2
		
		If TableOperations("Exist",ResultTable,"", "","") Then
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully searched object ["&dicSearchParameters("ObjectName")&"].","","","","","")
			Fn_SearchInWindChill=True
		Else
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to search object ["&dicSearchParameters("ObjectName")&"]..","","","","","")
			Call Fn_ExitFromTest()
		End If
		
	End If
End Function


''*******************************************************************************
''Function to Search Project in library 
''*******************************************************************************
Public Function Fn_SearchProjectInLibrary(sAction,sProjectName,dicProjectDetails)
	
Fn_SearchProjectInLibrary=False
Dim objTable
Set objTable=Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_LibarySearch")
objTable.SetTOProperty "xpath","//DIV[@id='folderbrowser_PDM.toolBar']/TABLE[1]/TBODY[1]/TR[1]/TD[2]/TABLE[1]/TBODY[1]/TR[1]/TD[1]/TABLE[1]"
objTable.WebEdit("weedt_LibraryName").SetTOProperty  "xpath","//INPUT[@id='folderbrowser_PDM.searchInListTextBox']"
objTable.Image("LibSearchImage").SetTOProperty "xpath","//DIV[@id='folderbrowser_PDM.toolBar']/TABLE[1]/TBODY[1]/TR[1]/TD[2]/TABLE[1]/TBODY[1]/TR[1]/TD[1]/TABLE[1]/TBODY[1]/TR[1]/TD[3]/DIV[1]/SPAN[1]/IMG[2]"

Select Case sAction
	Case "Search"
	If objTable.Exist(2) Then
		objTable.WebEdit("weedt_LibraryName").highlight
		objTable.WebEdit("weedt_LibraryName").Set sProjectName
		wait 1
		objTable.Image("LibSearchImage").Click
		Browser("Start_Browser").Sync
		wait 1
		
		If TableOperations("Exist","projectsearchresultstable","", "","") Then
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully searched project ["&sProjectName&"]in library .","","","","","")
			Fn_SearchProjectInLibrary=True
		Else
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to search project ["&sProjectName&"] in library.","","","","","")
			Call  Fn_ExitFromTest()
		End If
		
	End If
	
Case "Search_WithoutSync"
	GLOBAL_PERFORMANCE_ACTION="Searching of Project"
	If objTable.Exist(2) Then
		objTable.WebEdit("weedt_LibraryName").highlight
		objTable.WebEdit("weedt_LibraryName").Set sProjectName
		wait 1
		objTable.Image("LibSearchImage").Click
		Browser("Start_Browser").Sync
		GBL_FUNCTION_EXECUTION_START_TIME=timer
		If dicProjectDetails("ExistTimeOut")="" Then
			dicProjectDetails("ExistTimeOut")="180"
		End If
		If dicProjectDetails("NonExistTimeOut") ="" Then
			dicProjectDetails("NonExistTimeOut")="300"
		End If
				
		sTimeStamp=  Fn_WaitForSync("WaitForExistance",Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FolderContents"),dicProjectDetails("ObjType"),dicProjectDetails("ObjName"),"","",dicProjectDetails("ExistTimeOut"))	

		GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FolderContents"),dicProjectDetails("ObjType"),dicProjectDetails("ObjName"),"","",dicProjectDetails("NonExistTimeOut"))	
		GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
		
			
		If Err.Number < 0 Then
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_SearchProjectInLibrary",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			Fn_SearchProjectInLibrary = False
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to search project ["&sProjectName&"] in library.","","","","","")
			Call Fn_ExitFromTest()

		Else
		
			If TableOperations("Exist","projectsearchresultstable","", "","") Then
				Fn_SearchProjectInLibrary = True
				GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
				Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_SearchProjectInLibrary",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully searched project ["&sProjectName&"]in library .","","","","","")
			End If
			
		End If
		
	End If
End Select
		
End Function
''*******************************************************************************
''Function to Search objects in Windchill
''*******************************************************************************
Public Function Fn_SearchObjectsInWindchill(dicSearchParameters)
	
	Fn_SearchObjectsInWindchill=False
	
	Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Suchen").Click
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Suchen link","","","","","")
	
	Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Suchen").SetTOProperty "innertext","Suchverlauf und gespeicherte Suchen"
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Suchverlauf und gespeicherte Suchen link","","","","","")
	
	
	iRowCount = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetROProperty("rows")
	If iRowCount = 0 Then
		If dicSearchParameters("PredefinedSearch")<> ""  Then
			Call Fn_AddPredefinedSearch(dicSearchParameters("PredefinedSearch"))
		Else
			Call Fn_AddPredefinedSearch("ECAD")
		End If
	End If
	
	If dicSearchParameters("PredefinedSearch")<> ""  Then
			Call Fn_AddPredefinedSearch(dicSearchParameters("PredefinedSearch"))
	End If
	
	If Fn_SelectPredefinedSearch(dicSearchParameters("PredefinedSearch")) Then
			
			If dicSearchParameters("Criteria")<> "" Then
				Select Case Lcase(dicSearchParameters("Criteria"))
					Case "windchillnumber"
						If dicSearchParameters("Number")<> "" Then
							If  Fn_WEB_UI_WebObject_Operations("Fn_SearchObjectsInWindchill","Exist",Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_Windchillnumber") ,"","","") Then
								Call Fn_WEB_UI_WebEdit_Operations("Fn_SearchObjectsInWindchill","Set",Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_Windchillnumber"), "",dicSearchParameters("Number") )
								Browser("Start_Browser").Sync
								Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered Windchill Number as [" & dicSearchParameters("Number") & "] on  search page","","","","","")
							Else 
								Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of Windchill Number edit box.","","","","","")
								Call Fn_ExitFromTest()
							End If
						End If
					
					Case "mannumber"
					
						If dicSearchParameters("Number")<> "" Then
							If  Fn_WEB_UI_WebObject_Operations("Fn_SearchObjectsInWindchill","Exist",Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_SearchManNumber") ,"","","") Then
								Call Fn_WEB_UI_WebEdit_Operations("Fn_SearchObjectsInWindchill","Set",Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_SearchManNumber") ,"",dicSearchParameters("Number") )
								Browser("Start_Browser").Sync
								Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered MAN Number as [" & dicSearchParameters("Number") & "] on  search page","","","","","")
							Else 
								Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of MAN Number edit box.","","","","","")
								Call Fn_ExitFromTest()
							End If
						End If
					
				End Select
			End If
			
		If Lcase(dicSearchParameters("AllTypeSearch"))="yes" Then
			wait 1
			Browser("Start_Browser").Page("Windchill_Getstarted").WebCheckBox("Wechk_AllTypes").highlight
			Browser("Start_Browser").Page("Windchill_Getstarted").WebCheckBox("Wechk_AllTypes").Set "ON"
		End If
		
		If Lcase(dicSearchParameters("AllContext"))="yes" Then
			Browser("Start_Browser").Page("Windchill_Getstarted").WebCheckBox("Wechk_AllTypes").SetTOProperty "xpath","//INPUT[@id='all_contexts']"
			Browser("Start_Browser").Page("Windchill_Getstarted").WebCheckBox("Wechk_AllTypes").highlight
			Browser("Start_Browser").Page("Windchill_Getstarted").WebCheckBox("Wechk_AllTypes").Set "ON"
		End If
		
	
	Else
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to Select predefined search from search table.","","","","","")
		Call Fn_ExitFromTest()
	End If 
	
	Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_Search").highlight
	Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_Search").Click
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Search button on  search page","","","","","")

	
	If Not(Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FirstSearchResult").Exist(20)) Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of search table","","","","","")
		Call Fn_ExitFromTest()
	Else
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully performed search using  number as [" & dicSearchParameters("Number") & "] as search results is displayed.","","","","","")
		Fn_SearchObjectsInWindchill=True
	End If


End  Function

''*******************************************************************************
''Function to Select PreDefined Search 
''Example: Fn_SelectPredefinedSearch("ECAD")
''*******************************************************************************
Public Function Fn_SelectPredefinedSearch(sSearchParameter)

Dim iRowCount,objTable
Fn_SelectPredefinedSearch=False
Set objTable=Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches")
iRowCount = objTable.GetROProperty("rows")

	For iCounter = 1 To iRowCount Step 1
		If 	Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetCellData(iCounter, 1) = sSearchParameter Then
			If Fn_Web_UI_WebTable_Operations("","executeobject",Browser("Start_Browser").Page("Windchill_Getstarted"),"wetbl_PreDefinedSearches","",iCounter,2,"","Image","","Click","","","","") = False Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on {"&sSearchParameter&"} link in predefined searches table","","","","","")
				Call Fn_ExitFromTest()
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on edit image for  {"&sSearchParameter&"} saved search","","","","","")
				Fn_SelectPredefinedSearch=True
				Exit For
				
			End If
		End If
	Next
End Function
''*******************************************************************************
''Function to Select Objects from Search Results
''*******************************************************************************
Public Function Fn_SelectObjectFromSearchResults(sColumns,sValues,dicSelectParameters)

	Dim bFound,aColumns,aData,iCount,objWebTable,aValues, bFlag, Iterator
	
		Set objWebTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FirstSearchResult")
		
	If sColumns <> "" Then
		aColumns=Split(sColumns,"~")
		For Iterator = 0 To uBound(aColumns)
			aColumns(Iterator)= TableOperations("getcolumnindex","searchtable","",aColumns(Iterator),"")
		Next
	End If
	
	If sValues<>"" Then
		aValues=Split(sValues,"~")
	End If
	
	bFound = True
	bFlag=False
	iRow=1
	Do While (bFound = True)
		objWebTable.SetTOProperty "xPath","//DIV[@id='wt.fc.Persistable.defaultSearchView']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iRow&"]/TABLE[1]"
		If objWebTable.Exist(2) Then
			For Iterator = 0 To uBound(aColumns)
				If objWebTable.GetCellData(1,aColumns(Iterator))=aValues(Iterator) Then
					'bFound = True
				Else	
					Exit For
				End If	
			Next
			If Iterator=(uBound(aColumns)+1) Then
				bFlag=True
				Exit Do
			End If
		Else
			bFound=False
		End If
		iRow=iRow+1
	Loop
	
	If bFlag Then
		 iDetailsImageIndex = TableOperations("getcolumnindex","searchtable","","Ansichtsinformationen","")
		Call Fn_Web_UI_WebTable_Operations("","executeobject",objWebTable,"",1,"",iDetailsImageIndex,"","Image","","Click","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on detail image in search results table","","","","","")
	Else 
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to clicked on detail image in search results table","","","","","")
	End If
	
End Function
''*******************************************************************************
''Function to select object from folder contents (Ordner inhalt) (Right side table after clicking on any foder at left side)
''*******************************************************************************
Public Function Fn_SelectObjectFromFolderContents(sColumns,sValues,dicSelectParameters)

	Dim bFound,aColumns,aData,iCount,objWebTable,aValues, bFlag, Iterator
	
	   Set objWebTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetable_FolderContents")
	  Set objSearchBox=Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("SearchInFolderContents")
	  Set objSearchIcon=Browser("Start_Browser").Page("Windchill_Getstarted").Image("SearchIcon")
	
	If dicSelectParameters("SearchParameter")<> "" Then
		If objSearchBox.Exist(1) Then
			objSearchBox.Set dicSelectParameters("SearchParameter")
			objSearchIcon.Highlight
			objSearchIcon.Click
		End If
	End If

	  If sColumns <> "" Then
		aColumns=Split(sColumns,"~")
		For Iterator = 0 To uBound(aColumns)
			aColumns(Iterator)= TableOperations("getcolumnindex","foldercontentsheadertable","",aColumns(Iterator),"")
		Next
	End If
	
	If sValues<>"" Then
		aValues=Split(sValues,"~")
	End If
	
	bFound = True
	bFlag=False
	iRow=1
	Do While (bFound = True)
		objWebTable.SetTOProperty "xPath","//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iRow&"]/TABLE[1]"
		If objWebTable.Exist(2) Then
			For Iterator = 0 To uBound(aColumns)
				If objWebTable.GetCellData(1,aColumns(Iterator))=aValues(Iterator) Then
					bFound = True
				Else	
					Exit For
				End If	
			Next
			If Iterator=(uBound(aColumns)+1) Then
				bFlag=True
				Exit Do
			End If
		Else
			bFound=False
		End If
		iRow=iRow+1
	Loop
	
	If bFlag Then
		 iDetailsImageIndex = TableOperations("getcolumnindex","foldercontentsheadertable","","Ansichtsinformationen","")
		Call Fn_Web_UI_WebTable_Operations("","executeobject",objWebTable,"",1,"",iDetailsImageIndex,"","Image","","Click","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on detail image in folder contents table","","","","","")
		Fn_SelectObjectFromFolderContents=True
	Else 
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to clicked on detail image in folder contentstable","","","","","")
		Fn_SelectObjectFromFolderContents=False
	End If
	
End Function
''*******************************************************************************
''Function for performing folder operations
''*******************************************************************************
Public Function Fn_FolderContentsOperations(sAction,sColumns,sValues,dicInfoParameters)
Dim bFound,aColumns,aData,iCount,objWebTable,aValues, bFlag, Iterator
	
	   Set objWebTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetable_FolderContents")
	  Set objSearchBox=Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("SearchInFolderContents")
	  Set objSearchIcon=Browser("Start_Browser").Page("Windchill_Getstarted").Image("SearchIcon")
	  
	  Select Case sAction
	  	Case "SearchInFolder"
	  		If dicInfoParameters("SearchParameter")<> "" Then
				If objSearchBox.Exist(1) Then
				objSearchBox.highlight
				objSearchBox.Set dicInfoParameters("SearchParameter")
				objSearchIcon.Highlight
				objSearchIcon.Click
				End If
			End If
			objWebTable.SetTOProperty "xPath","//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/TABLE[1]"
			If objWebTable.Exist(2)  Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully searched ["&dicInfoParameters("SearchParameter")&"] in folder contents table","","","","","")
				Fn_FolderContentsOperations=True
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to search ["&dicInfoParameters("SearchParameter")&"] in folder contentstable","","","","","")
				Fn_FolderContentsOperations=False
			End If
			
		Case "ClickInfoOfObject"
		
		  If sColumns <> "" Then
			aColumns=Split(sColumns,"~")
			For Iterator = 0 To uBound(aColumns)
				aColumns(Iterator)= TableOperations("getcolumnindex","foldercontentsheadertable","",aColumns(Iterator),"")
			Next
		End If
	
		If sValues<>"" Then
			aValues=Split(sValues,"~")
		End If
	
		bFound = True
		bFlag=False
		iRow=1
		Do While (bFound = True)
			objWebTable.SetTOProperty "xPath","//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iRow&"]/TABLE[1]"
			If objWebTable.Exist(2) Then
				For Iterator = 0 To uBound(aColumns)
					If objWebTable.GetCellData(1,aColumns(Iterator))=aValues(Iterator) Then
						bFound = True
					Else	
						Exit For
					End If	
				Next
				If Iterator=(uBound(aColumns)+1) Then
					bFlag=True
					Exit Do
				End If
			Else
				bFound=False
			End If
			iRow=iRow+1
		Loop
	
		If bFlag Then
			 iDetailsImageIndex = TableOperations("getcolumnindex","foldercontentsheadertable","","Ansichtsinformationen","")
			Call Fn_Web_UI_WebTable_Operations("","executeobject",objWebTable,"",1,"",iDetailsImageIndex,"","Image","","Click","","","","")
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on detail image in folder contents table","","","","","")
			Fn_FolderContentsOperations=True
		Else 
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to clicked on detail image in folder contentstable","","","","","")
			Fn_FolderContentsOperations=False
		End If
		
		Case "VerifyTooltipOfObjectIndicator"
			bFound = True
			bFlag=False
			iRow=1
		Do While (bFound = True)
			objWebTable.SetTOProperty "xPath","//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iRow&"]/TABLE[1]"
			objWebTable.highlight
			If objWebTable.Exist(2) Then
				Set descImage = Description.Create
				descImage("html tag").value = "IMG"
				Set listImages = objWebTable.ChildObjects(descImage)
				
				' Check tool tips of images
				For i = 0 To listImages.Count - 1
				    aData=  listImages(i).GetROProperty("outerhtml")
				 	If Instr(aData,dicInfoParameters("ToolTip")) Then
				 		bFlag=True
				 		Exit for
				 	Else
				 		bFlag=False
				 	End If
				Next
	
			Else
				bFound=False
			End If
			iRow=iRow+1
			If bFlag=True Then
				Exit Do
			End If
		Loop
		If bFlag=True Then
		 	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified tooltip of the object as ["&dicInfoParameters("ToolTip")&"]","","","","","")
			Fn_FolderContentsOperations=True
			GBL_FUNCTION_EXECUTION_END_TIME=timer
		Else 
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify tooltip of the object as ["&dicInfoParameters("ToolTip")&"]","","","","","")
			Fn_FolderContentsOperations=False
		End If
			
	  End Select
End Function
''*******************************************************************************
''Function to perform tab operations
''*******************************************************************************

Public Function TabOperations(sAction,sTabName,DicTabDetails)
TabOperations=False
Dim sTimeStamp,sMenu,DeviceReplay,x,y

	Select Case sAction
		Case "Select"
		If sTabName<> "" Then
			Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").SetTOProperty "innertext",sTabName
			If Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").exist(2) Then
				Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").highlight
				Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").Click
				Browser("Start_Browser").Sync
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on ["&sTabName&"] tab.","","","","","")
				TabOperations=True
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on ["&sTabName&"] tab.","","","","","")
			End If
			
		End If
		
		Case "Select_WithoutSync"
		GLOBAL_PERFORMANCE_ACTION="Loading Of "&sTabName&" Tab"
		If sTabName<> "" Then
			Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").SetTOProperty "innertext",sTabName
			If Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").exist(2) Then
				Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").highlight
				Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").Click
				Browser("Start_Browser").Sync
				GBL_FUNCTION_EXECUTION_START_TIME=timer
				If DicTabDetails("ExistTimeOut")="" Then
					DicTabDetails("ExistTimeOut")="180"
				End If
				If DicTabDetails("NonExistTimeOut") ="" Then
					DicTabDetails("NonExistTimeOut")="300"
				End If
				
				sTimeStamp=  Fn_WaitForSync("WaitForExistance",DicTabDetails("ObjContainer"),DicTabDetails("ObjType"),DicTabDetails("ObjName"),"","",DicTabDetails("ExistTimeOut"))	
				If DicTabDetails("WaitForNonExistance")="yes" Then
					GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",DicTabDetails("ObjContainer"),DicTabDetails("ObjType"),DicTabDetails("ObjName"),"","",DicTabDetails("NonExistTimeOut"))	
				Else
					GBL_FUNCTION_EXECUTION_END_TIME=sTimeStamp
				End If
				
				''Performance Time Calculation
				GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action"," ["&sTabName&"] tab link does not exist.","","","","","")
			End If
			
			If Err.Number < 0 Then
				GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
				Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","TabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
				TabOperations = False
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on ["&sTabName&"] tab..","","","","","")
				Call Fn_ExitFromTest()
			Else
				TabOperations = True
				GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
				Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","TabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on ["&sTabName&"] tab.","","","","","")
			End If
			
		End If
		
			Case "VerfiyTabExist"
					If sTabName<> "" Then
						Select Case sTabName
							Case "Filter Bearbeiten"
							Set objButton=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebButton("Show") 
							objButton.SetTOProperty "innertext",sTabName
							If objButton.Exist(3) Then
								TabOperations=True
							Else
								TabOperations=False
							End If
						End Select
					End If
		Case  "SelectTabFromList"
			If sTabName<> "" Then
			Set DeviceReplay = CreateObject("Mercury.DeviceReplay")
					sMenu=Split(sTabName,"~")
					Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebButton("ExtraTabsbutton").Click
					If Ubound(sMenu)=0 Then
						Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").SetTOProperty "innertext",sMenu(0)
						Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").highlight
						Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").Click 
						TabOperations=True
					Else
						For iCounter = 0 To uBound(sMenu) Step 1
				 			Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").SetTOProperty "innertext",sMenu(iCounter)
							Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").highlight
							x=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").GetROProperty("abs_x")
							y=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View").GetROProperty("abs_y")
							DeviceReplay.MouseClick x+5,y+5,LEFT_MOUSE_BUTTON
							TabOperations=True
			 		Next
			 		GBL_FUNCTION_EXECUTION_START_TIME=timer
			 		End If
								 		
			 		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu [" & sTabName & "]","","","","","")
				
			End If
	End Select

End Function


''*******************************************************************************
''Function for  (Optionspool tab Operations)
''*******************************************************************************
Public Function OptionspoolTabOperations(sAction,dicDetails)
	OptionspoolTabOperations=False
Dim objViewEdit
Set objViewEdit=Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_OptionTypeCombo")

If sAction<> "" Then
	Select Case sAction
		Case"SelectView"
			If dicDetails("ViewName") <> "" Then
				objViewEdit.highlight
				objViewEdit.Set dicDetails("ViewName")
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected view ["&dicDetails("ViewName")&"] in optionspool tab.","","","","","")
				OptionspoolTabOperations=True
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select ["&dicDetails("ViewName")&"] view in optionspool tab..","","","","","")
			End If
			
			
	End Select
End If

End Function

''*******************************************************************************
''Function for show view operations (Structure tab Operations)
''*******************************************************************************
Public Function StructureTabOperations(sAction,DicDetails)
StructureTabOperations=False

Dim objViewTable,objViewLink,sTimeStamp,WshShell
Dim absx,absy,devreplay
Set objFrame=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame")
Set objViewTable=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebTable("wetbl_ViewsTable")
Set objViewLink=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Link("welnk_View")
Set objSearchEdit=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebEdit("weedt_SearchNumber")
Set objSearchingElement=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebElement("SearchingLabel")
Set objShowButton=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebButton("Show")
Set objInternalTab=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebElement("FilterTabs")

If sAction<> "" Then
	Select Case sAction
		Case "SelectView"
			If DicDetails("ViewName")<>"" Then
				If objViewTable.Exist(5) Then
					objViewTable.highlight
					objViewTable.Click
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					wait 4
					objViewLink.SetTOProperty "innertext",DicDetails("ViewName")
					If objViewLink.exist(5) Then
						objViewLink.highlight
						objViewLink.Click
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected view ["&DicDetails("ViewName")&"] in structure tab.","","","","","")
						StructureTabOperations=True
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of link ["&DicDetails("ViewName")&"] in structure tab..","","","","","")
					End If
					
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of View table in structure tab.","","","","","")
				End If
					
			End If
			
		Case "SearchStructure_WithoutSync"
			GLOBAL_PERFORMANCE_ACTION="Perform Search Action"
			If objSearchEdit.exist(2) Then
				objSearchEdit.Set DicDetails("SearchItem")
				wait 1
				Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").Image("SearchImage").Click
				GBL_FUNCTION_EXECUTION_START_TIME=timer
					
				sTimeStamp=  Fn_WaitForSync("WaitForExistance",Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame"),"WebElement","SearchingLabel","","","300")	

				GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame"),"WebElement","SearchingLabel","","","100")	
				''Performance Time Calculation
				GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
				
				If Err.Number < 0 Then
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","StructureTabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
					StructureTabOperations = False
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to search e set in structure tab..","","","","","")
					Call Fn_ExitFromTest()
	
				Else
					StructureTabOperations = True
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","StructureTabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully searched e set in structure tab.","","","","","")
				End If
		End If
			Case "SelectInternalTab"
			
				If objFrame.exist(2) Then
					objInternalTab.SetTOProperty "innertext",DicDetails("TabName")
					objInternalTab.highlight
					objInternalTab.Click
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected ["&DicDetails("TabName")&"] in structure tab.","","","","","")
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select ["&DicDetails("TabName")&"] in structure tab..","","","","","")
				End If	
			
			Case "SelectInternalTab_WithoutSync"
				
			GLOBAL_PERFORMANCE_ACTION="Loading Of internal tab "& DicDetails("TabName")
			If objFrame.exist(2) Then
				objInternalTab.SetTOProperty "innertext",DicDetails("TabName")
				objInternalTab.highlight
				objInternalTab.Click
				
				GBL_FUNCTION_EXECUTION_START_TIME=timer
					
				sTimeStamp=  Fn_WaitForSync("WaitForExistance",objFrame,"WebElement","LoadingLabel","","","300")	

				GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",objFrame,"WebElement","LoadingLabel","","","600")	
				''Performance Time Calculation
				GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
				
				If Err.Number < 0 Then
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","StructureTabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
					StructureTabOperations = False
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select ["&DicDetails("TabName")&"] in structure tab..","","","","","")
					Call Fn_ExitFromTest()
	
				Else
					StructureTabOperations = True
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","StructureTabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected ["&DicDetails("TabName")&"] in structure tab..","","","","","")
				End If
		End If
			
			Case "ExpandAllLevels_WithoutSync"
				GLOBAL_PERFORMANCE_ACTION="Expand All Levels Action"
				If DicDetails("Menu") <> "" Then
				
					If Instr(DicDetails("Menu"),"~") Then
						aMenu=Split(DicDetails("Menu"),"~")
					End If
				
						If objShowButton.Exist(5) Then
							objShowButton.highlight
							objShowButton.Click
							Browser("Start_Browser").Page("Windchill_Getstarted").Sync
							wait 2
							
							For Iterator = 0 To Ubound(aMenu)
								objViewLink.SetTOProperty "innertext",aMenu(Iterator)
								If objViewLink.exist(5) Then
									objViewLink.highlight
									If Iterator= UBound(aMenu) Then
										objViewLink.Click
										GBL_FUNCTION_EXECUTION_START_TIME=timer
										StructureTabOperations=True
									Else
									
										Set WshShell = CreateObject("WScript.Shell")
										WshShell.SendKeys "{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{RIGHT}"
										wait 3
										
										Set WshShell = Nothing
										
									End If
									
								Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu ["&aMenu(Iterator)&"] in structure tab.","","","","","")
								Else
									Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of menu ["&DicDetails("Menu")&"] in structure tab..","","","","","")
									Call Fn_ExitFromTest()
								End If
							Next
							
						Else
							Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of Show Button  structure tab.","","","","","")
							Call Fn_ExitFromTest()
						End If
						
				End If
				
				sTimeStamp=  Fn_WaitForSync("WaitForExistance",Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame"),"WebElement","StatusLabel","","","300")	

				GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame"),"WebElement","StatusLabel","","","900")	
				
		
				''Performance Time Calculation
				GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
				
				If Err.Number < 0 Then
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","StructureTabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
					StructureTabOperations = False
	
				Else
					StructureTabOperations = True
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","StructureTabOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
				End If
		
		Case "ExpandAllLevels"
		
			If DicDetails("Menu") <> "" Then
				
					If Instr(DicDetails("Menu"),"~") Then
						aMenu=Split(DicDetails("Menu"),"~")
					End If
				
						If objShowButton.Exist(5) Then
							objShowButton.highlight
							objShowButton.Click
							Browser("Start_Browser").Page("Windchill_Getstarted").Sync
							wait 2
							
							For Iterator = 0 To Ubound(aMenu)
								objViewLink.SetTOProperty "innertext",aMenu(Iterator)
								If objViewLink.exist(5) Then
									objViewLink.highlight
									If Iterator= UBound(aMenu) Then
										objViewLink.Click
										StructureTabOperations=True
									Else
									
										Set WshShell = CreateObject("WScript.Shell")
										WshShell.SendKeys "{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{RIGHT}"
										wait 3
										
										Set WshShell = Nothing
										
									End If
								Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected menu ["&aMenu(Iterator)&"] in structure tab.","","","","","")
								Else
									Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of menu ["&DicDetails("Menu")&"] in structure tab..","","","","","")
									Call Fn_ExitFromTest()
								End If
							Next
					End If	
			End If
			
	End Select
End If
End Function
''*******************************************************************************
''Function to perform table operations
''*******************************************************************************
Public Function TableOperations(sAction,sTableName,sRow, sCol,dicTable)
	Dim xpath, objTable, iCounter, iColumnRowNumber, iColumnCount,ObjLink

If sTableName<> "" Then
	Select Case lCase(sTableName)
		Case "searchtable"
			xpath="//DIV[@id='wt.fc.Persistable.defaultSearchView']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/TABLE[1]"
		Case "librarysearchresultstable"
			xpath="//DIV[@id='netmarkets.library.list']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/TABLE[1]"
		Case "productsearchresultstable"
			xpath="//DIV[@id='netmarkets.product.list']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/TABLE[1]"
		Case "projectsearchresultstable"
			xpath="//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/TABLE[1]"
		Case "projectheaderesultstable"
			xpath="//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/TABLE[1]"
		Case "foldercontentsheadertable"
			xpath="//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/TABLE[1]"
			
	End Select
End If
	
	Set objTable=Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("HeaderTable")
	objTable.SetTOProperty "xpath", xpath
	objTable.highlight
	
	If Not objTable.Exist(5) Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to found ["&sTableName&"] table","","","","","")
	End If
	
	Select Case LCase(sAction)
		Case "getcolumnindex"
			iColumnCount=objTable.ColumnCount(1)
			iColumnRowNumber=1
			For iCounter = 1 to iColumnCount
				If  Trim(lcase(sCol)) = trim(lcase(objTable.GetCellData(iColumnRowNumber,iCounter))) Then
					TableOperations = iCounter
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully found column index of column ["&sCol&"] as ["&iCounter&"].","","","","","")
					Exit for
				End If
			Next
			Set objTable = Nothing
			
		Case "getcolumncount"
			TableOperations = objTable.ColumnCount(1)
		Case "exist"
			If objTable.Exist(2)   Then
				TableOperations=True
			End If
		Case "clicklinkoncell"
			Set ObjLink = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("HeaderTable").ChildItem(sRow,sCol,"Link",0)
			If (ObjLink is Nothing) Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find link on table","","","","","")
			Else
				ObjLink.highlight
				ObjLink.Click
				Browser("Start_Browser").Sync
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked link on table.","","","","","")
				TableOperations=True
			End If
			
	End Select
	
End Function

''*******************************************************************************
''Function to Search Drawing
''*******************************************************************************
Public Function Fn_SearchDrawing(sAction, sNumber )
	
	Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Suchen").Click
	Browser("Start_Browser").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Suchen link","","","","","")
	
	Select Case LCase(sAction)
		Case "bychangenumber"
			iRowCount = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetROProperty("rows")
			If iRowCount = 0 Then
				'Call Fn_AddPredefinedSearch("ECAD")
				Call Fn_AddPredefinedSearch("ELZ-Zeichnung")
			End If
			
			For iCounter = 1 To iRowCount
				If 	Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetCellData(iCounter, 1) = "ELZ-Zeichnung" Then
					Exit For
				End If
			Next
	
	
	
		
		For iCounter = 1 To iRowCount
			If 	Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetCellData(iCounter, 1) = "ELZ-Zeichnung" Then
	'			If Fn_Web_UI_WebTable_Operations("","executeobject",Browser("Start_Browser").Page("Windchill_Getstarted"),"wetbl_PreDefinedSearches","",iCounter,2,"ELZ-Zeichnung","Image","","Click","","","","") = False Then
	'				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on {ELZ-Zeichnung} link in predefined searches table","","","","","")
	'				Call Fn_ExitFromTest()
	'			Else
	'				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on edit image for ELZ-Zeichnung saved search","","","","","")
	'			End If
				Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").ChildItem(2, 2, "Image",0).click
	
				If Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("SearchChangeNumber").Exist(20) Then
					Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("SearchChangeNumber").Set sNumber
					Browser("Start_Browser").Sync
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered Number as [" & sNumber & "] on ELZ-Zeichnung  search page","","","","","")
					
					Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_Search").Click
					Browser("Start_Browser").Sync
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Search button on ELZ-Zeichnung  search page","","","","","")
					
					If Not(Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FirstSearchResult").Exist(20)) Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of search table","","","","","")
						Call Fn_ExitFromTest()
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully performed search using number as [" & sNumber & "] as search results is displayed.","","","","","")
					End If
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of MAN Number edit box.","","","","","")
					Call Fn_ExitFromTest()
				End If
				Exit For
			End If
		Next
	
	
	End Select
	
	
	'Sort the table results
	If Fn_Web_UI_WebElement_Operations("Fn_SearchDrawingUsingMANNumber","Click",Browser("Start_Browser").Page("Windchill_Getstarted"),"weelm_LastModification","","","") = False Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on latest modification column header","","","","","")
		Call Fn_ExitFromTest()
	Else
		If Not(Browser("Start_Browser").Page("Windchill_Getstarted").Image("weimg_TableSortImage").Exist(3)) Then
			If Fn_Web_UI_WebElement_Operations("Fn_SearchDrawingUsingMANNumber","Click",Browser("Start_Browser").Page("Windchill_Getstarted"),"weelm_LastModification","","","") = False Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on latest modification column header","","","","","")
				Call Fn_ExitFromTest()
			Else
				If Browser("Start_Browser").Page("Windchill_Getstarted").Image("weimg_TableSortImage").Exist(3) Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on latest modification column header to sort table search results with latest modified entry on top","","","","","")
				End If
			End If
		End If
	End If
	
	
End  Function
''*******************************************************************************
''Function to Select object from Search Results
''*******************************************************************************
Public Function Fn_SelectDrawingRowFromSearchResults()
	bFlag = False
	For iCounter2 = 1 To 10 Step 1
		Set objWebTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FirstSearchResult")
		If Not(objWebTable.Exist(3)) Then
			Exit For
		End If
		iCols = Cint(objWebTable.GetROProperty("cols"))
		iXMLImageIndex = -1
		iDetailsImageIndex = -1
		For iCounter = 1 To 10 Step 1
			Set objChildItem = objWebTable.ChildItem(1,iCounter,"Image",0)
			If Typename(objChildItem)="Nothing" Then
			Else
				Select Case objChildItem.ToString()
					'Case "[ file_xml ] image"
					Case "[ ELZ-Zeichnung ] image"
						iXMLImageIndex = iCounter
						bFlag = True
					Case "[ details ] image"
						iDetailsImageIndex = iCounter
					Case "[ Erzeugnis/Projekt ] image"
						iDetailsImageIndex = iCounter
				End Select
			End If
		Next
		
		If iXMLImageIndex <> -1 Then
			Exit For
		Else
			objWebTable.SetTOProperty "xpath", "//DIV[@id=""wt.fc.Persistable.defaultSearchView""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[" & iCounter2 & "]/TABLE[1]"
		End If
	Next
	Set objChildItem = Nothing
	
	If bFlag Then
		If Fn_Web_UI_WebTable_Operations("","executeobject",objWebTable,"",1,"",iDetailsImageIndex,"","Image","","Click","","","","") = False Then
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on detail image in search results table","","","","","")
			Call Fn_ExitFromTest()
		Else
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on detail image in search results table","","","","","")
		End If
	End If
	Set objWebTable = Nothing
	
	Browser("Start_Browser").Page("Windchill_Getstarted").Sync
	If Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Details").Exist(20) Then
		Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Details").Click
		Browser("Start_Browser").Page("Windchill_Getstarted").Sync
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified existence of details page","","","","","")
	End If
	
End Function
''*******************************************************************************
''Function to verify field values
''*******************************************************************************
Public Function Fn_VerifyTableFieldValues(sFieldName, sFieldValue)

	Dim iRowCount, objTable, iColumnIndex, iCounter, iCounter2
	Dim aFieldNames, aFieldValues
	
	aFieldNames = Split(sFieldName, "~")
	aFieldValues = Split(sFieldValue, "~")
	
	For iCounter2 = 0 To Ubound(aFieldNames) Step 1
	
		Select Case aFieldNames(iCounter2)
			Case "Name", "Status", "Hauptinhalt", "Geändert von", "Letzte Änderung"
				iColumnIndex = 2
				Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_NameInformation")
			Case "MAN Number"
				iColumnIndex = 2
				Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_BasisInformation")
				aFieldNames(iCounter2) = "MAN-Nummer"
			Case "Change Number"
				iColumnIndex = 2
				Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_BasisInformation")
				aFieldNames(iCounter2) = "Änderungsnummer"	
			Case "Version", "Typ"
				iColumnIndex = 1
				Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabAttributeTable")
			Case "Lebenszyklusstatus", "Speicherort","Teamvorlage"
				iColumnIndex = 5
				Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("SystemDescription")
			Case "Konstrukteur"
				iColumnIndex = 2
				Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_BasisInformation")
		End Select
		
		If Not(objTable.Exist(10)) Then
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of table [" & objTable.ToString() & " while verifying value of field [" & aFieldNames(iCounter2) & "] as [" & aFieldValues(iCounter2) & "]","","","","","")
			Call Fn_ExitFromTest()
		End If
		
		iRowCount = objTable.RowCount
		For iCounter = 1 To iRowCount Step 1
			If Instr(objTable.GetCellData(iCounter,iColumnIndex), aFieldNames(iCounter2)) > 0 Then
				If aFieldNames(iCounter2)="Letzte Änderung"  Then
					If InStr(objTable.GetCellData(iCounter,iColumnIndex + 1) , Trim(aFieldValues(iCounter2)))>0 Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verified value of field [" & aFieldNames(iCounter2) & "] contains [" & aFieldValues(iCounter2) & "]","","","","","")
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify value of field [" & aFieldNames(iCounter2) & "] contains [" & aFieldValues(iCounter2) & "]","","","","","")
						Call Fn_ExitFromTest()
					End If
				ElseIf aFieldNames(iCounter2)="Lebenszyklusstatus" Then
					If Instr(objTable.Cell(iCounter,iColumnIndex + 1).GetRoProperty("innerhtml"), "<b>"&aFieldValues(iCounter2)&"</b>") > 0 Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verified value of field [" & aFieldNames(iCounter2) & "] as [" & aFieldValues(iCounter2) & "]","","","","","")
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify value of field [" & aFieldNames(iCounter2) & "] as [" & aFieldValues(iCounter2) & "]","","","","","")
						Call Fn_ExitFromTest()
					End If
				Else
					If Trim(objTable.GetCellData(iCounter,iColumnIndex + 1)) = Trim(aFieldValues(iCounter2)) Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verified value of field [" & aFieldNames(iCounter2) & "] as [" & aFieldValues(iCounter2) & "]","","","","","")
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify value of field [" & aFieldNames(iCounter2) & "] as [" & aFieldValues(iCounter2) & "]","","","","","")
						Call Fn_ExitFromTest()
					End If
				End If
				Exit For
			End If
		Next
	Next
	
End Function
''*******************************************************************************
''Function to Add predefined search in windchill
''*******************************************************************************
Public Function Fn_AddPredefinedSearch(sSearchName)
Dim iRowCount,iCounter,objShell
	Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Verwalten").Click
	Browser("Start_Browser").Page("Windchill_Getstarted").Sync
	
	If Not(Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebTable("wetbl_ManageSavedSearches").Exist(20)) Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of saved searches table.","","","","","")
		Call Fn_ExitFromTest()
	End If
	
	For iCounter = 1 To 10 Step 1
		Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebTable("wetbl_ManageSavedSearches").SetTOProperty "xpath", "//DIV[@id=""wt.query.SavedQuery.defaultSearchView""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[" & iCounter & "]/TABLE[1]"
		Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebTable("wetbl_ManageSavedSearches")
		If objTable.Exist(5) Then
			If objTable.GetCellData(1,2) = sSearchName Then
				If Fn_Web_UI_WebTable_Operations("","executeobject",objTable,"","",iCounter,1,"","WebElement",1,"Click","","","","") = False Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on checkbox while selecting saved search for [" & sSearchName & "]","","","","","")
					Call Fn_ExitFromTest()
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on checkbox while selecting saved search for [" & sSearchName & "]","","","","","")
				End If
			End If
		Else
			Exit For
		End If
	Next
	'Click on Show Button
	Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebButton("webtn_Show").highlight
	Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebButton("webtn_Show").Click
	Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebButton("webtn_SearchButton").highlight
	Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_ManageSavedSearches").WebButton("webtn_SearchButton").Click
	Browser("Start_Browser").Page("Windchill_Getstarted").Sync
	
	Set objShell = CreateObject("WScript.Shell" )             
	  objShell.AppActivate "windchill"
	  wait 1
	 ' Send the F5 key for a refresh
	  objShell.SendKeys "{F5}"
	iRowCount = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetROProperty("rows")

	For iCounter = 1 To iRowCount Step 1
		If 	Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_PreDefinedSearches").GetCellData(iCounter, 1) = sSearchName Then
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully added  {"&sSearchName&"} predefined searches table.","","","","","")
			Fn_AddPredefinedSearch=True
			Exit For
		Else
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to add {"&sSearchName&"} link in predefined searches table.","","","","","")
			Call Fn_ExitFromTest()
		End If
	Next
	
End Function
''*******************************************************************************
''Function on structure table operations
''*******************************************************************************
Public Function Fn_StructureTableOperation(sAction, iRow, iCol, sFieldNames, sFieldsValues )
'	Dim iRow, bContinue
	Dim dicValues, iRowCount, i, bContinue, iNumberOfSheets
	If Not(Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabAttributeTable").Exist(20)) Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of structure page","","","","","")
		Call Fn_ExitFromTest()
	End If
	
	Select Case LCase(sAction)
		Case "getrowcount"
			iRow=1
			bContinue=true
			Do While(bContinue)
				xpath="//DIV[@id=""DOCSBTree""]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][2]/DIV[@role=""presentation""][1]/DIV[@role=""row""]["& iRow &"]/TABLE[@role=""presentation""][1]"
				Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree").SetTOProperty "xpath",xpath
				
				If Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree").Exist(5) Then
					iRow= iRow+1
				Else
					iRow=iRow-1
					Exit do
				End If
			Loop
			Fn_StructureTableOperation=iRow
		
		Case "selectrow"
			xpath="//DIV[@id=""DOCSBTree""]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][2]/DIV[@role=""presentation""][1]/DIV[@role=""row""]["& iRow &"]/TABLE[@role=""presentation""][1]"
			Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree").SetTOProperty "xpath",xpath
			
			If Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree").Exist(5) Then
				Fn_StructureTableOperation=true
				Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree").Click
			End If
			
			Wait 0,200
			
		Case "verifyuniquenumber"
			iRowCount= Fn_StructureTableOperation("GetRowCount", "", "", "", "" )
			bResult=False
			Set dicValues=CreateObject("Scripting.Dictionary")
			
			For i=1 To iRowCount
				bResult=Fn_StructureTableOperation("selectrow", i, "", "", "" )
				
				bResult=Fn_StructureTabAttributeTableOperation("getvalue", "Nummer:", "")
				If bResult<>False Then
					If dicValues.Exists(bResult) Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify that [Nummer] value is unique at "&bResult,"","","","","")
						Call Fn_ExitFromTest()
					Else
						dicValues.Add bResult,""
					End If
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to get value of [Nummer] on stucture tab page","","","","","")
					Call Fn_ExitFromTest()
				End If
			Next
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified that value of [Nummer] is unique in stucture","","","","","")
			Set dicValues = Nothing
		Case "verify"
		Dim sType, aFieldsValues
			
			'Fn_StructureTableOperation("verify", "", "", "", "ELZ-Zeichnungsblatt~_0001.gl2~In Arbeit")
			
			aFieldsValues=Split(sFieldsValues,"~")
			iRowCount= Fn_StructureTableOperation("GetRowCount", "", "", "", "" )
			bResult=False
			
			If InStr(sFieldsValues,"0001")>0 Then
				sType = "Sheet 1"
			ElseIf InStr(sFieldsValues,"0002")>0 Then
				sType = "Sheet 2"
			ElseIf InStr(sFieldsValues,"0003")>0 Then
				sType = "Sheet 3"
			Else
				sType = "Drawing"
			End If
			
			For i=1 To iRowCount
				bResult=Fn_StructureTableOperation("selectrow", i, "", "", "" )
				
				bResult=Fn_StructureTabAttributeTableOperation("getvalue", "Typ:", "")
				bResult1=Fn_StructureTabAttributeTableOperation("getvalue", "Hauptinhalt:", "")
				bResult2=Fn_StructureTabAttributeTableOperation("getinnerhtml", "Lebenszyklusstatus:", "")
				
				If bResult=aFieldsValues(0) And InStr(bResult1,aFieldsValues(1))>0 And Instr(bResult2, "<b>"&aFieldsValues(2)&"</b>") > 0 Then
					bResult=True
					Exit for
				End If
			
			Next
			
			If bResult=true Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verified that for ["& sType &"] value of [Typ], [Lebenszyklusstatus] is ["&aFieldsValues(0)&"] and ["&aFieldsValues(2)&"] respectively","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Failed to verify that for ["& sType &"] value of [Typ], [Lebenszyklusstatus] is ["&aFieldsValues(0)&"] and ["&aFieldsValues(2)&"] respectively","","","","","")
			End If
		Case "verifynumberofsheets"
			iRowCount= Fn_StructureTableOperation("GetRowCount", "", "", "", "" )
			bResult=False
			iNumberOfSheets=0
			For i=1 To iRowCount
				bResult=Fn_StructureTableOperation("selectrow", i, "", "", "" )
				
				bResult = Fn_StructureTabAttributeTableOperation("getvalue", "Typ:", "")
				If bResult="KAB-Zeichnungsblatt" Then
					iNumberOfSheets=iNumberOfSheets + 1
				End If
			Next
			
			If iNumberOfSheets=CInt(sFieldsValues) Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified that number of  sheets in structure are ["&iNumberOfSheets&"]","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Expected number of  sheets in structure are ["&sFieldsValues&"], in actual ["&iNumberOfSheets&"] are present","","","","","")
			End If

		Case "verifystatusvalue"
			bResult=False
			
			bResult=Fn_StructureTableOperation("selectrow", iRow, "", "", "" )
			
			bResult=Fn_StructureTabAttributeTableOperation("getinnerhtml", "Lebenszyklusstatus:", "")
				If bResult=False Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to get value of [Lebenszyklusstatus] on stucture tab page","","","","","")
					Call Fn_ExitFromTest()
				Else
					If Instr(bResult, "<b>"&sFieldsValues&"</b>") > 0 Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified that value of [Lebenszyklusstatus] is [Obsolet]","","","","","")
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify that [Nummer] value is unique","","","","","")
						Call Fn_ExitFromTest()
					End If
				End If
		Case "verifydrawing"
			
			Call Fn_StructureTableOperation("selectrow", iRow, "", "", "" )
			
			Call Fn_VerifyTableFieldValues("Typ", "ELZ-Zeichnung")
		
		Case "verifysheet"
			Call Fn_StructureTableOperation("selectrow", iRow, "", "", "" )
				
			Call Fn_VerifyTableFieldValues("Typ", "ELZ-Zeichnungsblatt")
	End Select

	
End Function
Public Function Fn_StructureTabAttributeTableOperation(sAction, sFieldName, sFieldValue)
	
	Dim objTable, iRowCount
	Fn_StructureTabAttributeTableOperation=false
	
	Browser("Start_Browser").Sync
	set objTable=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabAttributeTable")
	

	If objTable.Exist(5) Then
		
	Else
		ExitTest
	End If
	
	Select Case LCase(sAction)
		Case "getvalue"
		
			iColumnIndex=1
			
			iRowCount = objTable.RowCount
			For iCounter = 1 To iRowCount
				If Instr(objTable.GetCellData(iCounter,iColumnIndex), sFieldName) > 0 Then
					Fn_StructureTabAttributeTableOperation=objTable.GetCellData(iCounter,2)
					Exit For
				End If
			Next
		Case "getinnerhtml"
			iColumnIndex=1
			iRowCount = objTable.RowCount
			For iCounter = 1 To iRowCount
				If Instr(objTable.GetCellData(iCounter,iColumnIndex), sFieldName) > 0 Then
					Fn_StructureTabAttributeTableOperation=objTable.Cell(iCounter,2).GetRoProperty("innerhtml")
					Exit For
				End If
			Next
		
		
	End Select

End  Function
Public Function Fn_VerifyStructureTabFielValues(sFieldName, sFieldValue)
	Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Structure").Click
	Browser("Start_Browser").Sync
	
	If Not(Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabAttributeTable").Exist(20)) Then
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify existence of structure page","","","","","")
		Call Fn_ExitFromTest()
	Else
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on [Structure] link and verified existence of structure page","","","","","")
	End If
	
	aFieldNames = Split(sFieldName, "~")
	
	For iCounter2 = 0 To Ubound(aFieldNames) Step 1
		Select Case LCase(aFieldNames(iCounter2))
			Case "version"
				Call Fn_VerifyTableFieldValues(sFieldName, sFieldValue)
				
			Case ""
		End Select
	Next
End Function
Public Function Fn_GetDrawingAndSheetInformationFromStructureTab()
	Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree")
	For iCounter = 1 To 10 Step 1
		objTable.SetTOProperty "xpath", "//DIV[@id=""DOCSBTree""]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][2]/DIV[@role=""presentation""][1]/DIV[@role=""row""][" & iCounter & "]/TABLE[@role=""presentation""][1]"
		If objTable.Exist(3) Then
			If iCounter = 1 Then
				sDrawingName = objTable.GetCellData(1,1)
			Else
				If sDrawingSheetName = "" Then
					sDrawingSheetName = objTable.GetCellData(1,1)
				Else
					sDrawingSheetName = sDrawingSheetName & "~" & objTable.GetCellData(1,1)
				End If
			End If
		Else
			Exit For
		End If
	Next
	Call Fn_CommonUtil_DataTableOperations("AddColumn","StructureTabDrawingName","","")
	Datatable.Value("StructureTabDrawingName", "Global") = sDrawingName
	
	Call Fn_CommonUtil_DataTableOperations("AddColumn","StructureTabDrawinSheetNames","","")
	Datatable.Value("StructureTabDrawinSheetNames", "Global") = sDrawingSheetName
	
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully retrieved drawing name as [" & sDrawingName & "] from structure tab.","","","","","")
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully retrieved drawing sheet name as [" & sDrawingSheetName & "] from structure tab.","","","","","")
End Function
Public Function Fn_SelectDrawingSheetAndInitiateNewPromotionRequest(sAction, sSelectType,dicPromoReq)
	'Dim sRow, sDate, j
	'Dim i, aProperty, aValues
	Dim iRow, sPromoReqNo
	
	Select Case LCase(sSelectType)
		Case "drawing",""
			sRow=1
		Case "sheet"
			sRow=2
	End Select
	
	Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabeFrame").WebTable("wetbl_StructureTabDrawingTree")
	objTable.SetTOProperty "xpath", "//DIV[@id=""DOCSBTree""]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][1]/DIV[@role=""presentation""][2]/DIV[@role=""presentation""][1]/DIV[@role=""row""]["&sRow&"]/TABLE[@role=""presentation""][1]"
	If objTable.Exist(3) Then
		Set objChildItem = objTable.ChildItem(1,1,"WebElement",0)
		If Typename(objChildItem)="Nothing" Then
			Set objChildItem =Nothing
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select ["&sSelectType&"] on structure tab","","","","","")
			Call Fn_ExitFromTest()
			Exit function
		End If
		objChildItem.Click
		Browser("Start_Browser").Page("Windchill_Getstarted").Sync
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected  ["&sSelectType&"] on structure tab","","","","","")
	End If
	
	Call ActionMenuOpertion("Select", "Neu~Neuer Erhöhungsantrag")
	
	'verify
	
	If dicPromoReq("VerifyDetails")=True Then
			If Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebElement("Type").GetROProperty("innertext")=dicPromoReq("Type") Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verify that [Type] value is ["&dicPromoReq("Type")&"] on [set attribute] page of raise promotion request","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify that [Type] value is ["&dicPromoReq("Type")&"] on [set attribute] page of raise promotion request","","","","","")
			End If
			
			sDate=Date()
			dicPromoReq("Name")=dicPromoReq("Name")&" "&Split(sDate,".")(2) & Split(sDate,".")(1) & Split(sDate,".")(0)
			If InStr(Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebEdit("Name").GetROProperty("value"),dicPromoReq("Name"))>0 Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verify that [Name] value contains ["&dicPromoReq("Name")&"] on [set attribute] page of raise promotion request","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify that [Name] value contains ["&dicPromoReq("Name")&"] on [set attribute] page of raise promotion request","","","","","")
			End If
			
			If  Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebEdit("ChangeNumber").GetROProperty("value")=dicPromoReq("ChangeNumber") Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verify that [ChangeNumber] value is ["&dicPromoReq("ChangeNumber")&"] on [set attribute] page of raise promotion request","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify that [ChangeNumber] value is ["&dicPromoReq("ChangeNumber")&"] on [set attribute] page of raise promotion request","","","","","")
			End If
	End If
	
	If Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Exist(15) Then
		Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Highlight
		Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Click	
		Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").Sync
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Next button on page1","","","","","")
	End If
	
	If Cint(Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebElement("weelm_RaisedTargetStatus").GetROProperty("width")) > 0 Then
		Set objTable=Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebTable("TargetStatusTable")
		
		If dicPromoReq("PromotionObjectVerification")=True Then			
			For iCount = 1 To 4
				Datatable.SetCurrentRow iCount
				If Datatable.Value("WindchillNumber")<>"" Then
					bFound=False
					For iRow = 1 To 3
						objTable.SetTOProperty "xpath", "//DIV[@id=""promotionRequest.promotionObjects""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["& iRow&"]/TABLE[1]"
						If objTable.GetCellData(1,9)=Datatable.Value("WindchillNumber") Then
							sType=objTable.ChildItem(1,8,"Image",0).GetRoProperty("file name")
							sType=Replace(sType,".gif","")
							If sType=Datatable.Value("Type") And  objTable.GetCellData(1,12)=Datatable.Value("LifeCycleStatus") And objTable.GetCellData(1,13)=Datatable.Value("PromotionStatus") Then
								bFound=true
								Exit For
							End If
						End If
					Next
					If bFound=False Then
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify that ["&Datatable.Value("Type")&"] with Winchill number ["&Datatable.Value("WindchillNumber")&"] have lifecycle and Promotion status as ["&Datatable.Value("LifeCycleStatus")&"] and ["&Datatable.Value("PromotionStatus")&"] are present in table","","","","","")
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verify that ["&Datatable.Value("Type")&"] with Winchill number ["&Datatable.Value("WindchillNumber")&"] have lifecycle and Promotion status as ["&Datatable.Value("LifeCycleStatus")&"] and ["&Datatable.Value("PromotionStatus")&"] are present in table","","","","","")
					End If
				End If
			Next
		End If
		
		If Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Exist(15) Then
			Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Highlight
			Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Click	
		End If
	Else
		Wait 5
		Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Next").Click	
	End If
	Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Next button on page2","","","","","")
	
	If Cint(Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebElement("weelm_Process").GetROProperty("width")) > 0 Then
		If Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Finish").Exist(15) Then
			Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Finish").Click	
		End If
	Else
		Wait 5
		Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").WebButton("webtn_Finish").Click	
	End If
	Browser("webr_NewPromotionRequest").Page("wepg_NewPromotionRequest").Sync
	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Finish button on last page","","","","","")

	If Browser("Start_Browser").Page("Windchill_Getstarted").Link("ProjectName").Exist(5) Then
		sPromoReqNo=Browser("Start_Browser").Page("Windchill_Getstarted").Link("ProjectName").GetROProperty("text")
		sPromoReqNo=Trim(Split(sPromoReqNo,"- ")(1))
		
		Call Fn_CommonUtil_DataTableOperations("AddColumn","FunctionReturnValue","","")
		Datatable.Value("FunctionReturnValue", "Global") =sPromoReqNo
		
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully fetched promotion request number["& sPromoReqNo &"]","","","","","")
	Else
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to fetch promotion request number","","","","","")
	End If
End Function

Public Function Fn_HomePageMyTasksOperation(sAction, sInvokeOption, sTextToVerify)
	
	Select Case sInvokeOption
		Case "HomeButton", "homebutton", "home"
			Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("weelm_HomePageIcon").Click
			Browser("Start_Browser").Page("Windchill_Getstarted").Sync
	End Select
	
	Select Case sAction
		Case "VerifyInProcessTaskExists", "GetRowNumberForTask"
			Fn_HomePageMyTasksOperation = False
			Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_MyTasks")
			bFlag = False
			bAttemptRetry = True
			For iCounter = 1 To 10 Step 1
				objTable.SetTOProperty "xpath","//DIV[@id=""projectmanagement.overview.assignments.list""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[" & iCounter & "]/TABLE[1]"
				If objTable.Exist(3) Then
					If Instr(Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_MyTasks").GetCellData(1,8), sTextToVerify) > 0 Then
						bFlag = True
						If sAction = "GetRowNumberForTask" Then
							Fn_HomePageMyTasksOperation = iCounter
						End If
						Exit For
					End If
				Else
					If bAttemptRetry Then
						Wait 5
						Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("weelm_HomePageIcon").Click
						Browser("Start_Browser").Page("Windchill_Getstarted").Sync
						iCounter = 0
						bAttemptRetry = False
					Else
						Exit For
					End If
				End If
			Next
			
			If sAction <> "GetRowNumberForTask" Then
				If bFlag Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verified existence of string [" & sTextToVerify & "] in my tasks table.","","","","","")
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify existence of string [" & sTextToVerify & "] in my tasks table.","","","","","")
					Call Fn_ExitFromTest()
				End If
			End If
		
		Case "CompletePromotionRequestTask"
		
			iCounter = Fn_HomePageMyTasksOperation("GetRowNumberForTask", sInvokeOption, sTextToVerify)
			Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_MyTasks")
			objTable.SetTOProperty "xpath","//DIV[@id=""projectmanagement.overview.assignments.list""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[" & iCounter & "]/TABLE[1]"
			
			If objTable.Exist(3) Then
				Set objChildItem = objTable.ChildItem(1,5,"Image",0)
				objChildItem.Click
				If Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_Comments").Exist(20) Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Details image from my tasks table row.","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_Comments").Set "Comments"
					
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered comments as [Comments].","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					Browser("Start_Browser").Page("Windchill_Getstarted").WebRadioGroup("werdb_RoutingOption").Select "Approve"
					
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected [Approve] radio option.","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_CompleteTask").Click
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on [Complete Task] button.","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					
					If Browser("Start_Browser").Page("Windchill_Getstarted").Link("ProjectName").Exist(5) Then
		 				sProjectName=Browser("Start_Browser").Page("Windchill_Getstarted").Link("ProjectName").GetROProperty("text")
		 				sProjectName=Split(sProjectName,",")(0)
		 				sProjectName=Split(sProjectName,"- ")(1)
		 				Call Fn_CommonUtil_DataTableOperations("AddColumn","FunctionReturnValue","","")
		 				Datatable.Value("FunctionReturnValue", "Global") =sProjectName
		 				
		 				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully fetched project name ["& sProjectName &"]","","","","","")
		 			Else
		 				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to fetch newly created project name","","","","","")
		 			End If
					
				End If
			End If
		Case "RejectPromotionRequest", "ApprovePromotionRequest"
			Dim sPerform
			If sAction="RejectPromotionRequest" Then
				sPerform="Reject"
			ElseIf sAction="AcceptPromotionRequest" Then
				sPerform="Approve"
			End If
			iCounter = Fn_HomePageMyTasksOperation("GetRowNumberForTask", sInvokeOption, sTextToVerify)
			Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_MyTasks")
			objTable.SetTOProperty "xpath","//DIV[@id=""projectmanagement.overview.assignments.list""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[" & iCounter & "]/TABLE[1]"
			
			If objTable.Exist(3) Then
				Set objChildItem = objTable.ChildItem(1,5,"Image",0)
				objChildItem.Click
				If Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_Comments").Exist(20) Then
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Details image from my tasks table row.","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").WebEdit("weedt_Comments").Set "Comments"
					
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered comments as [Comments].","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					Browser("Start_Browser").Page("Windchill_Getstarted").WebRadioGroup("werdb_RoutingOption").Select sPerform
					
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected ["&sPerform&"] radio option.","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_CompleteTask").Click
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on [Complete Task] button.","","","","","")
					Browser("Start_Browser").Page("Windchill_Getstarted").Sync
					
				End If
			End If
			
			
		Case "VerifyPromotionRequestTaskNotExist"
		
			If Fn_HomePageMyTasksOperation("GetRowNumberForTask", sInvokeOption, sTextToVerify) = False Then
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_verification","Successfully verified non existence of string [" & sTextToVerify & "] in my tasks table.","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_verification","Failed to verify non existence of string [" & sTextToVerify & "] in my tasks table.","","","","","")
				Call Fn_ExitFromTest()
			End If
			
	End Select

End Function
Public Function Fn_RowTableOperations(sTableName, sTableStringValue, iRowNumber, iColumnNumber)

	Fn_RowTableOperations = False
	Select Case sTableName
		Case "MyTasks"
			Set objTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_MyTasks")
			sXPathValue = "//DIV[@id=""projectmanagement.overview.assignments.list""]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[VariableValue]/TABLE[1]"
	End Select
	
	For iCounter = 1 To 100 Step 1
		objTable.SetTOProperty "xpath",Replace(sXPathValue, "VariableValue", Cstr(iCounter))
		If objTable.Exist(3) Then
			If Instr(objTable.GetCellData(iRowNumber,iColumnNumber), sTableStringValue) > 0 Then
				Fn_RowTableOperations = iCounter
				Exit For
			End If
		Else
			Exit For
		End If
	Next
	
End Function

Public Function Fn_GetWindchillNumberFromStructure()
	Dim sType, iRowCount,sNumber, iRowNumber, sStatus
	
		iRowCount= Fn_StructureTableOperation("GetRowCount", "", "", "", "" )
		bResult=False
		
		Call Fn_CommonUtil_DataTableOperations("AddColumn","Type","","")
		Call Fn_CommonUtil_DataTableOperations("AddColumn","WindchillNumber","","")
		iRowNumber =Datatable.GetCurrentRow
		For i=1 To iRowCount
			Call Fn_StructureTableOperation("selectrow", i, "", "", "" )
			Wait 0,200
			sStatus=Fn_StructureTabAttributeTableOperation("getinnerhtml", "Lebenszyklusstatus:", "")
			if InStr(sStatus,"<b>Obsolet</b>")>0 Then
				'Do nothing
			Else
				Datatable.SetCurrentRow iRowNumber+i-1
				Datatable.Value("WindchillNumber")=Fn_StructureTabAttributeTableOperation("getvalue", "Nummer:", "")
				Datatable.Value("Type")=Fn_StructureTabAttributeTableOperation("getvalue", "Typ:", "")
			End If
		Next
End Function


Public Function LastVisitedTreeOperations(sAction,sInvokeOption,sNodePath)
	Err.clear
	Dim aTreeNode, iCount, objFolderList
	LastVisitedTreeOperations=false
	
	Select Case sInvokeOption
		Case "Durchsuchen", "durchsuchen", "foldersearch", "FolderSearch"
			Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Durchsuchen").Click
			wait 1
								
		Case "Search", "search", "Suchen", "suchen"
			Browser("Start_Browser").Page("Windchill_Getstarted").Link("weln_Suchen").Click 5,5,micLeftBtn
	End Select
	
	Set objFolderList = Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("FolderList")
	
	Select Case sAction
		Case "Select"
			
		Case "ExpandAndSelect"
			aTreeNode=Split(sNodePath,"~")
			For iCount = 0 To UBound(aTreeNode)-1
				objFolderList.WebElement("Node").SetTOProperty "innertext",aTreeNode(iCount)
				If  objFolderList.WebElement("Node").Exist(2) Then
					If objFolderList.Image("Expand").Exist(1) Then
						objFolderList.Image("Expand").highlight
						objFolderList.Image("Expand").Click 5,5,micLeftBtn
					ElseIf objFolderList.Image("Collapse").Exist(1) Then
						'objFolderList.WebElement("Node").SetTOProperty "innertext",aTreeNode(1)
						'objFolderList.WebElement("Node").Click 10,10,micLeftBtn
						'LastVisitedTreeOperations=True
						'Do Nothing 
					Else
						Fn_ExitTest
					End If
				End If
			Next
			
			objFolderList.WebElement("Node").SetTOProperty "innertext",aTreeNode(uBound(aTreeNode))
			
			If  objFolderList.WebElement("Node").Exist(2) Then
				objFolderList.WebElement("Node").highlight
				objFolderList.WebElement("Node").Click
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on ["&sNodePath&"]","","","","","")
				LastVisitedTreeOperations=True
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to expand and select node ["&sNodePath&"]","","","","","")
			End If
	End Select
End Function

'''***************************************************************************************
'*******************************************************************************
''Function to Select Project from library Search Results
''*******************************************************************************
Public Function Fn_SelectProjectFromLibrarySearchResults(sColumns,sValues,dicSelectParameters)

Fn_SelectProjectFromLibrarySearchResults=False
	Dim bFound,aColumns,aData,iCount,objWebTable,aValues, bFlag, Iterator
	
	Set objWebTable = Browser("Start_Browser").Page("Windchill_Getstarted").WebTable("wetbl_FirstSearchResult")
	objWebTable.SetTOProperty "xpath","//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV[1]/TABLE[1]"
	objWebTable.highlight
	If sColumns <> "" Then
		aColumns=Split(sColumns,"~")
		For Iterator = 0 To uBound(aColumns)
			aColumns(Iterator)= TableOperations("getcolumnindex","projectheaderesultstable","",aColumns(Iterator),"")
		Next
	End If
	
	If sValues<>"" Then
		aValues=Split(sValues,"~")
	End If
	
	bFound = True
	bFlag=False
	iRow=1
	Do While (bFound = True)
		objWebTable.SetTOProperty "xPath","//DIV[@id='folderbrowser_PDM']/DIV[1]/DIV[2]/DIV[1]/DIV[1]/DIV[2]/DIV[1]/DIV["&iRow&"]/TABLE[1]"
		If objWebTable.Exist(2) Then
			For Iterator = 0 To uBound(aColumns)
				If objWebTable.GetCellData(1,aColumns(Iterator))=aValues(Iterator) Then
					'bFound = True
				Else	
					Exit For
				End If	
			Next
			If Iterator=(uBound(aColumns)+1) Then
				bFlag=True
				Exit Do
			End If
		Else
			bFound=False
		End If
		iRow=iRow+1
	Loop
	
	If bFlag Then
		 iDetailsImageIndex = TableOperations("getcolumnindex","projectheaderesultstable","","Ansichtsinformationen","")
		Call Fn_Web_UI_WebTable_Operations("","executeobject",objWebTable,"",1,"",iDetailsImageIndex,"","Image","","Click","","","","")
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on detail image in search results table","","","","","")
		Fn_SelectProjectFromLibrarySearchResults=True
	Else 
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to clicked on detail image in search results table","","","","","")
	End If
	
	'	Browser("Start_Browser").Page("Windchill_Getstarted").Sync
	'	If Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Details").Exist(20) Then
	'		Browser("Start_Browser").Page("Windchill_Getstarted").Link("welnk_Details").Click
	'		Browser("Start_Browser").Page("Windchill_Getstarted").Sync
	'		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified existence of details page","","","","","")
	'	End If
End Function
''*******************************************************************************
''Function to sync structure tab
''Example: msgbox Fn_WaitForSync("WaitForNonExistance",Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame"),"WebElement","StatusLabel","visible","False","30000")
''*******************************************************************************
Public Function Fn_WaitForSync(sAction,objWebContainer,sObjectType,sObjectName,sProperty,sValue,iMaxTimeout)

Fn_StructureTabSync=False
Dim Object,sWaitTime,sTimeStamp
sWaitTime=0

Select Case sObjectType
	Case "WebElement"
	Set Object=objWebContainer.WebElement(sObjectName)
	Case "WebTable"
	Set Object=objWebContainer.WebTable(sObjectName)
	Case "Page"
	Set Object=objWebContainer.Page(sObjectName)
	Case "WebEdit"
	Set Object=objWebContainer.WebEdit(sObjectName)
End Select

If iMaxTimeout="" Then
	iMaxTimeout=GBL_MAX_TIMEOUT
End If

Select Case sAction
	Case "WaitForExistance"
		If Not (Object is Nothing) Then
			'Status=Object.WaitProperty("Exist","True",iMaxTimeout)
			Do 
				If Object.Exist(1) Then
					Object.highlight
					sTimeStamp=timer
					Exit Do
				End If
				sWaitTime=sWaitTime+1
			Loop While(sWaitTime< iMaxTimeout)
			If sTimeStamp  Then
				Fn_WaitForSync=sTimeStamp
			Else
				Fn_WaitForSync=False
			End If
			
		End If
		
	Case "WaitForNonExistance"
		If Not (Object is Nothing)  Then
			Do 
				If Not Object.Exist(1) Then
					sTimeStamp=timer
					Exit Do
				End If
				sWaitTime=sWaitTime+1
			Loop While(sWaitTime< iMaxTimeout)
			If sTimeStamp  Then
				Fn_WaitForSync=sTimeStamp
			Else
				Fn_WaitForSync=False
			End If
		End If
End Select
End Function
''*******************************************************************************
''Function to create new part
''Example: msgbox Fn_CreateNewPart()
''*******************************************************************************
Public Function Fn_CreateNewPart(sAction,sProductType,sManNo,sInfoSadis,dicPartDetails,sButton)
	Fn_CreateNewPart=False
	Dim ManNo
	If not Browser("NewPart").Page("NewPartPage").Exist(2) Then
		Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_NewPart").Click
		wait GBL_MIN_TIMEOUT
	End If
	
	Select Case sAction 
		Case "SetAttributes"
			If Browser("NewPart").Page("NewPartPage").Exist(2) Then
				If sProductType<> "" Then
					Browser("NewPart").Page("NewPartPage").WebList("weblst_ProductType").highlight
					Browser("NewPart").Page("NewPartPage").WebList("weblst_ProductType").Select sProductType
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [ProductType] value as [" & sProductType & "]","","","","","")
				End If
				wait GBL_MICRO_TIMEOUT
				If sManNo<>"" Then
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").highlight
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").Set sManNo
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [Man Number] value as [" & sManNo & "]","","","","","")
				End If
					
				wait GBL_MICRO_TIMEOUT
				
				
				If Lcase(sInfoSadis)="yes" Then
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_InfoSadis").Click
					GBL_FUNCTION_EXECUTION_START_TIME=timer
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked Info Sadis Button","","","","","")
				End If
				
				Do
					ManNo=Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").GetROProperty ("value")
				Loop While (ManNo = sManNo )
				GBL_FUNCTION_EXECUTION_END_TIME=timer
				
				If dicPartDetails("Name")<>"" Then
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_Name").highlight
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_Name").Set dicPartDetails("Name")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [Name] value as [" & dicPartDetails("Name") & "]","","","","","")
				End If
				If dicPartDetails("Name_EN")<>"" Then
				Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").SetTOProperty "xpath","//INPUT[@id='name_en']"
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").highlight
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").Set dicPartDetails("Name_EN")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [Name_EN] value as [" & dicPartDetails("Name_EN") & "]","","","","","")
				End If
				
				If dicPartDetails("Department")<>"" Then
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_Department").highlight
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_Department").Set dicPartDetails("Department")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [Department] value as [" & dicPartDetails("Department") & "]","","","","","")
				End If
				
				If dicPartDetails("PG_ID")<>"" Then
				Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").SetTOProperty "xpath","//INPUT[@id='pg_id']"
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").highlight
					Browser("NewPart").Page("NewPartPage").WebEdit("weedt_ManNo").Set dicPartDetails("PG_ID")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [PG_ID] value as [" & dicPartDetails("PG_ID") & "]","","","","","")
				End If
				
				
				If dicPartDetails("Produktart")<>"" Then
					Browser("NewPart").Page("NewPartPage").WebList("weblst_ProductType").SetTOProperty "xpath","//DIV[@id='!~objectHandle~partHandle~!CreatePartAttributesPanel_attributesTable__AttributesTablePaneInner_wt.part.WTPart|com.ptc.PGStructureItems|com.ptc.ComponentVariant']/FIELDSET[4]/DIV[1]/DIV[1]/DIV[1]/TABLE[1]/TBODY[1]/TR[1]/TD[3]/DIV[2]/SELECT[1]"
					Browser("NewPart").Page("NewPartPage").WebList("weblst_ProductType").highlight
					Browser("NewPart").Page("NewPartPage").WebList("weblst_ProductType").Select  dicPartDetails("Produktart")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [Produktart] value as [" & dicPartDetails("Produktart") & "]","","","","","")
				End If
				
				If sProductType="Komponentenvariante (KV)" Then
							
				If dicPartDetails("GeometrieRelevant  ")<>"" Then
					Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").SetTOProperty "xpath","//SELECT[@id='geometrie_relevant']"
					Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").highlight
					Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").Select  dicPartDetails("GeometrieRelevant")
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [GeometrieRelevant] value as [" & dicPartDetails("GeometrieRelevant") & "]","","","","","")
				Else
					Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").SetTOProperty "xpath","//SELECT[@id='geometrie_relevant']"
					Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").highlight
					Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").Select  "Ja"
					Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [GeometrieRelevant] value as [Ja]","","","","","")
				End If
			         End If			
				If Browser("NewPart").Page("NewPartPage").WebElement("weelm_InfoDialog").Exist (1) Then
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").SetTOProperty "innertext","OK"
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").highlight
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").Click
				End If
				wait GBL_MICRO_TIMEOUT
							
				If sButton<> "" Then
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").SetTOProperty "innertext",sButton
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").highlight
					Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").Click
					GBL_FUNCTION_EXECUTION_START_TIME1=timer
				End If
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","New part dialog does not exist.","","","","","")
			End If
					
			If dicPartDetails("Transaction")<> "" Then
					If dicPartDetails("Transaction")="Edit_KV" Then
					GLOBAL_PERFORMANCE_ACTION="Time for Edit KV"
						GBL_FUNCTION_EXECUTION_END_TIME1=Fn_WaitForSync("WaitForNonExistance",dicPartDetails("objContainer"),dicPartDetails("objType"),dicPartDetails("objName"),"","","120")
						GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME1-GBL_FUNCTION_EXECUTION_START_TIME1))
						If Err.Number < 0 Then
							GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
							Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_CreateNewPart",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
							Fn_CreateNewPart = False
							Call Fn_ExitFromTest()
				
						Else
								GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
								Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_CreateNewPart",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
								Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully set attributes on create part dialog.","","","","","")
						End If
			
					End If
				End If	
			GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
			GLOBAL_PERFORMANCE_ACTION="Time to generate Dummy Man Number"
				If Err.Number < 0 Then
				
					GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
					Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_CreateNewPart",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
					Fn_CreateNewPart = False
					Call Fn_ExitFromTest()
		
				Else
						Fn_CreateNewPart = ManNo
						GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
						Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_CreateNewPart",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully set attributes on create part dialog.","","","","","")
				End If
			
			Case "NewCADDocument"
				If Browser("NewPart").Page("NewPartPage").Exist(2) Then
					If dicPartDetails("TemplateName")<> "" Then
						Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").highlight
						Browser("NewPart").Page("NewPartPage").WebList("Weblst_TemplateName").Select dicPartDetails("TemplateName")
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully entered [TemplateName] value as [" & dicPartDetails("TemplateName") & "]","","","","","")
					End If
					If sButton<> "" Then
						Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").SetTOProperty "innertext",sButton
						Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").highlight
						Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").Click
						GLOBAL_PERFORMANCE_ACTION="Time until Blue LE is displayed after complete"
						GBL_FUNCTION_EXECUTION_START_TIME=timer
					End If
					Fn_CreateNewPart=True
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","New part dialog does not exist.","","","","","")
					Fn_CreateNewPart=False
				End If
			
					
	End Select
End Function
''*******************************************************************************
''Function to click home page icon
''Example: msgbox Fn_ResetHomePage()
''*******************************************************************************
Public Function Fn_ResetHomePage()
	Fn_ResetHomePage=False
	If Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("HomePageIcon").Exist(2)  Then
		Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("HomePageIcon").highlight
		Browser("Start_Browser").Page("Windchill_Getstarted").WebElement("HomePageIcon").Click
		Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on Home page image .","","","","","")
		Fn_ResetHomePage=True
	Else
		Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on Home Page image.","","","","","")
		Call Fn_ExitFromTest()
	End If
End Function

''
''*******************************************************************************
''Function to close windchill
''Example: msgbox Fn_ResetHomePage()
''*******************************************************************************
Public Function Fn_CloseWindchill()
	Fn_CloseWindchill=False
	err.clear
	'until no more browsers exist
	While Browser("creationtime:=0").Exist(0)
		'Close the browser
		Browser("creationtime:=0").Close
	Wend
 	
 	SystemUtil.CloseProcessByName("iexplorer.exe")
 	Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully logged out from windchill by closing the browser.","","","","","")
 	Fn_CloseWindchill=True
End Function
''*******************************************************************************
''Function  to assign id to a component
''*******************************************************************************
Public Function Fn_AssignIdToObject(sAction,dicObjectDetails,sButton)
	Fn_AssignIDToObject=False
	Dim objBrowser,objPage,objEditName,sTimeStamp
	Set objBrowser=Browser("NewPart")
	objBrowser.SetTOProperty "title","Verlinkungs-Assistent"
	Set objPage=Browser("NewPart").Page("NewPartPage")
	objPage.SetTOProperty "title","Verlinkungs-Assistent"
	Set objEditName=Browser("NewPart").Page("NewPartPage").WebEdit("weedt_assignIdName")

	If not objBrowser.exist(2) Then
		Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenu").highlight
		Browser("Start_Browser").Page("Windchill_Getstarted").WebButton("webtn_ActionMenu").Click
                  Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").SetTOProperty "text","ID Zuweisen"
                   Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").highlight
		Browser("Start_Browser").Page("Windchill_Getstarted").Link("MenuLink").Click
		wait GBL_DEFAULT_MIN_TIMEOUT
	End If
	
	Select Case sAction
		Case "AssignId"
			GLOBAL_PERFORMANCE_ACTION="Searching Object to Assign ID"
			If dicObjectDetails("Name")<> "" Then
				objEditName.highlight
				objEditName.Set dicObjectDetails("Name")
			End If
			
			If sButton<>"" Then
				Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").SetTOProperty "innertext",sButton
             		         Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").highlight
             		         Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").Click
             		         GBL_FUNCTION_EXECUTION_START_TIME=timer
             		End If
			If dicObjectDetails("ExistTimeOut")="" Then
			dicObjectDetails("ExistTimeOut")="30"
			End If
		If dicObjectDetails("NonExistTimeOut") ="" Then
			dicObjectDetails("NonExistTimeOut")="120"
		End If
				
		sTimeStamp=  Fn_WaitForSync("WaitForExistance",dicObjectDetails("ObjContainer"),dicObjectDetails("ObjType"),dicObjectDetails("ObjName"),"","",dicObjectDetails("ExistTimeOut"))	

		GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForNonExistance",dicObjectDetails("ObjContainer"),dicObjectDetails("ObjType"),dicObjectDetails("ObjName"),"","",dicObjectDetails("NonExistTimeOut"))	
		GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
		
			
		If Err.Number < 0 Then
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_AssignIdToObject",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			Fn_AssignIdToObject = False
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to assign id to object .","","","","","")
			Call Fn_ExitFromTest()
		Else
			Fn_AssignIdToObject = True
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_AssignIdToObject",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully assigned id to object .","","","","","")
		End If
		
	End Select
End Function
''*******************************************************************************
''Function for edit filter operations (Filter bearbeiten)
''
''*******************************************************************************
Public Function Fn_EditFilterOperations(sAction,sTab,DicTabDetails,sButton)
	Fn_EditFilterOperations=False
	Dim objFrame,objButton
	
	Set objFrame=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame")
	Set objButton=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebButton("Show")
	Set objTab=Browser("Start_Browser").Page("Windchill_Getstarted").Frame("wefrm_StructureTabFrame").WebElement("FilterTabs")

	Select Case sAction
		
	Case "SelectFilters"
			If DicTabDetails("FilterOption")<>"" Then
				objFrame.SetTOProperty "index",0
				If objFrame.Exist(4) Then
					objFrame.highlight
					objButton.SetTOProperty "innertext",DicTabDetails("FilterOption")
					If objButton.exist(1) Then
						objButton.highlight
						objButton.Click
						Browser("Start_Browser").Page("Windchill_Getstarted").Sync
						wait GBL_MICRO_TIMEOUT
						Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected filter ["&DicDetails("FilterOption")&"] in structure tab.","","","","","")
						Fn_EditFilterOperations=True
					Else
						Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of button ["&DicDetails("FilterOption")&"] in structure tab..","","","","","")
						Fn_EditFilterOperations=False
					End If
					
				Else
					Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to find existence of frame in structure tab.","","","","","")
				End If
					
			End If
	Case "SelectTab"
		GLOBAL_PERFORMANCE_ACTION="Loading Of "&sTab&" Tab"
		If objFrame.Exist(1) Then
			If sTab<> "" Then
				objTab.highlight
				objTab.Click
				GBL_FUNCTION_EXECUTION_START_TIME=timer
				If DicTabDetails("ExistTimeOut")="" Then
					DicTabDetails("ExistTimeOut")="180"
				End If
				If DicTabDetails("WaitForExistance")="yes" Then
					GBL_FUNCTION_EXECUTION_END_TIME=  Fn_WaitForSync("WaitForExistance",DicTabDetails("ObjContainer"),DicTabDetails("ObjType"),DicTabDetails("ObjName"),"","",DicTabDetails("ExistTimeOut"))	
				End If
				''Performance Time Calculation
				GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
				
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully selected tab ["&sTab&"] in edit filter dialog.","","","","","")
				Fn_EditFilterOperations=True
			End If
		Else
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to select tab ["&sTab&"] in edit filter dialog.","","","","","")
			Fn_EditFilterOperations=False
		End If
		
		If Err.Number < 0 Then
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","EditFilterOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			Fn_EditFilterOperations = False
			Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to click on ["&sTab&"] tab..","","","","","")
			Call Fn_ExitFromTest()
		Else
			Fn_EditFilterOperations = True
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","EditFilterOperations",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on ["&sTab&"] tab.","","","","","")
		End If
		
End Select
End Function

''*******************************************************************************
''Function  to create new konfigurationskontext (DPC)
''*******************************************************************************
Public Function Fn_CreateNewDPC(sAction,dicObjectDetails,sButton)
	Fn_CreateNewDPC=False
	Dim objBrowser,objPage,objEditName,sTimeStamp
	Set objBrowser=Browser("NewPart")
	objBrowser.SetTOProperty "title","Neuer Konfigurationskontext"
	Set objPage=Browser("NewPart").Page("NewPartPage")
	objPage.SetTOProperty "title","Neuer Konfigurationskontext"
	Set objEditName=Browser("NewPart").Page("NewPartPage").WebEdit("weedt_DpcName")

	If not objBrowser.exist(2) Then
 		Call ActionMenuOpertion("select", "Neu~Neuer Konfigurationskontext")
		wait GBL_DEFAULT_MIN_TIMEOUT
	End If
	
	Select Case sAction
		Case "CreateDPC"
			GLOBAL_PERFORMANCE_ACTION="Create DPC"
			If dicObjectDetails("Name")<> "" Then
				objEditName.highlight
				objEditName.Set dicObjectDetails("Name")
			End If
			
			If sButton<>"" Then
				Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").SetTOProperty "innertext",sButton
             		         Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").highlight
             		         Browser("NewPart").Page("NewPartPage").WebButton("webtn_Continue").Click
             		         Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully clicked on ["&sButton&"] tab.","","","","","")
             		         GBL_FUNCTION_EXECUTION_START_TIME=timer
             		End If
	
		
	End Select
End Function
''*******************************************************************************
''Function  to download file and verify
''*******************************************************************************
Public Function Fn_DownloadAndVerifyFile(sAction,dicFileDetails)
	Fn_DownloadAndVerifyFile=False
	Dim sUser,sPath,sFileName,stemp
	Select Case sAction
		Case "SaveAndVerify"
		If  Browser("Start_Browser").WinObject("FileDwnload_Popup").Exist(10) Then
			Browser("Start_Browser").WinObject("FileDwnload_Popup").WinButton("WinBtn_Save").highlight
			Browser("Start_Browser").WinObject("FileDwnload_Popup").WinButton("WinBtn_Save").Click
		End If
		If dicFileDetails("FileName")<> "" Then
			sFileName=Browser("Start_Browser").WinObject("FileDwnload_Popup").Static("StaticTxt_FileName").GetROProperty("text")
			If instr(sFileName,dicFileDetails("FileName") )Then
				Fn_DownloadAndVerifyFile=True
				Call Fn_LogUtil_PrintAndUpdateScriptLog("pass_action","Successfully verified ["&sFileName&"] file exist .","","","","","")
			Else
				Call Fn_LogUtil_PrintAndUpdateScriptLog("fail_action","Failed to verify ["&sFileName&"] file exist.","","","","","")
			End If
		End If
'			
		GBL_FUNCTION_EXECUTION_END_TIME=timer
		GLOBAL_PERFORMANCE_ACTION="Time for exporting list to XLSX "
		''Performance Time Calculation
		GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME=cStr(round(GBL_FUNCTION_EXECUTION_END_TIME-GBL_FUNCTION_EXECUTION_START_TIME))
		If Err.Number < 0 Then
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_FAIL
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_DownloadAndVerifyFile",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
			Fn_DownloadAndVerifyFile = False
			Call Fn_ExitFromTest()
		Else
			Fn_DownloadAndVerifyFile = True
			GLOBAL_PERFORMANCE_ACTION_RESULT = GLOBAL_PERFORMANCE_ACTION_PASS		
			Call Fn_LogUtil_UpdateTestScriptBusinessFunctionalityAverageTimeDurationInExcel("","updateperformancedetails","Fn_DownloadAndVerifyFile",GLOBAL_PERFORMANCE_ACTION,Cstr(GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME),GLOBAL_PERFORMANCE_ACTION_RESULT,"","")
		End If
	End Select
End Function

