. 'C:\Users\lenovo\.gemini\config\skills\sql-procedures-generator\scripts\db_helper.ps1'

 = @(
    'tblPlaces_GPS',
    'tblHR_Employees',
    'tblHR_Shifts',
    'tblHR_EmployeeShifts',
    'tblHR_Attendance',
    'tblHR_LeaveTypes',
    'tblHR_Leaves',
    'tblHR_Deductions_Rewards',
    'tblHR_Payroll'
)

foreach ( in ) {
    Write-Host Generating 5 SPs for ... -ForegroundColor Yellow
    Generate-FiveStoredProcedures -TableName  -DatabaseName 'PharmacyQandilDB' -Execute | Out-Null
}

Write-Host All 45 Stored Procedures generated and executed successfully! -ForegroundColor Green