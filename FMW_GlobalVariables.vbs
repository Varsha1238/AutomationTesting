Option Explicit

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for time in seconds
Public GBL_DEFAULT_TIMEOUT, GBL_MICRO_TIMEOUT, GBL_MIN_TIMEOUT, GBL_MAX_TIMEOUT,GBL_DEFAULT_MIN_TIMEOUT,GBL_MIN_MICRO_TIMEOUT
GBL_MAX_TIMEOUT = 90 'time in seconds
GBL_DEFAULT_TIMEOUT = 20 'time in seconds
GBL_DEFAULT_MIN_TIMEOUT = 10 'time in seconds
GBL_MIN_TIMEOUT = 5 'time in seconds
GBL_MIN_MICRO_TIMEOUT = 2 'time in seconds
GBL_MICRO_TIMEOUT = 1 'time in seconds
GBL_FOLDER_EXIST_TIMEOUT = 720 'time in seconds

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for number of sync iterations
Public GBL_DEFAULT_SYNC_ITERATIONS, GBL_MICRO_SYNC_ITERATIONS, GBL_MIN_SYNC_ITERATIONS, GBL_MAX_SYNC_ITERATIONS,GBL_MIN_MICRO_SYNC_ITERATIONS,GBL_APP_SYNC_ITERATIONS
GBL_MAX_SYNC_ITERATIONS = 10 'number of iterations
GBL_DEFAULT_SYNC_ITERATIONS = 5 'number of iterations
GBL_MIN_SYNC_ITERATIONS = 3 'number of iterations
GBL_MIN_MICRO_SYNC_ITERATIONS = 2 'number of iterations
GBL_MICRO_SYNC_ITERATIONS = 1 'number of iterations
GBL_APP_SYNC_ITERATIONS=""

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for test case log type
Public GBL_LOG_STEP_HEADER, GBL_LOG_FAIL_VERIFICATION, GBL_LOG_PASS_VERIFICATION,GBL_LOG_FAIL_ACTION, GBL_LOG_PASS_ACTION,GBL_SCRIPT_RESULT
GBL_LOG_STEP_HEADER = "step_header"
GBL_LOG_FAIL_VERIFICATION = "fail_verification"
GBL_LOG_PASS_VERIFICATION = "pass_verification"
GBL_LOG_FAIL_ACTION = "fail_action"
GBL_LOG_PASS_ACTION = "pass_action"

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for test case step information
Public GBL_STEP_NUMBER,GBL_STEP_DESCRIPTION,GBL_STEP_EXPECTED_RESULT,GBL_STEP_EXECUTION_TIME
GBL_STEP_NUMBER = 0

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for application names
Public GBL_APP_NAME_TO_EXIT_ON_FAILURE,GBL_APP_NAME_TO_SYNC,GBL_CURRENT_EXECUTABLE_APP

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for execution times
Public GBL_FUNCTION_EXECUTION_START_TIME,GBL_FUNCTION_EXECUTION_END_TIME
Public GBL_FUNCTION_EXECUTION_START_TIME1,GBL_FUNCTION_EXECUTION_END_TIME1
Public GBL_TEST_EXECUTION_START_TIME, GBL_TEST_EXECUTION_END_TIME,GBL_TEST_EXECUTION_TOTAL_TIME,GLOBAL_PERFORMANCE_ACTION_RESULT
GBL_TEST_EXECUTION_START_TIME=""
GBL_TEST_EXECUTION_END_TIME=""
GBL_TEST_EXECUTION_TOTAL_TIME=""

''Action Specific variables
Public GLOBAL_PERFORMANCE_ACTION_FAIL
GLOBAL_PERFORMANCE_ACTION_FAIL="FAIL"
Public GLOBAL_PERFORMANCE_ACTION_PASS
GLOBAL_PERFORMANCE_ACTION_PASS="PASS"
Public GLOBAL_PERFORMANCE_ACTION,GBL_FUNCTION_EXECUTION_PERFORMANCE_TIME


' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for automation standard prefix
Public GBL_AUTOMATION_PREFIX
GBL_AUTOMATION_PREFIX="SQS_AUT"

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for counters
Public GBL_VERIFICATION_COUNTER

GBL_VERIFICATION_COUNTER=1
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for datatable current set row number
Public GBL_DATATABLEGLOBALSHEETCURRENTROW_NUMBER

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for function log
Public GBL_FUNCTIONLOG
GBL_FUNCTIONLOG=""

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables for log updation time
Public GBL_LAST_LOG_UPDATION_TIME

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables used for function Fn_RAC_ReadyStatusSync
Public GBL_TCOBJECTS_SYNC_FLAG,GBL_TCOBJECTS_SYNC_XAXIS,GBL_TCOBJECTS_SYNC_YAXIS
GBL_TCOBJECTS_SYNC_FLAG = False

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variable to indicate whether to disable print and update log functionality
Public GBL_DISABLEPRINTANDUPDATELOG_REPORTING
GBL_DISABLEPRINTANDUPDATELOG_REPORTING=False

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variable to store additional log information
Public GBL_LOG_ADDITIONAL_INFORMATION
GBL_LOG_ADDITIONAL_INFORMATION = ""

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variables to store teamcenter syslog image path
Public GBL_SYSLOG_IMAGE_PATH
GBL_SYSLOG_IMAGE_PATH=""

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'Global variable to store HP UFT product name
Public GBL_HP_QTP_PRODUCTNAME
GBL_HP_QTP_PRODUCTNAME="HP Unified Functional Testing"

Public GBL_EXPORT_FOLDER_OPERATION_TIME
