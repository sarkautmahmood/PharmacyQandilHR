-- Verification queries for PharmacyQandilHR
USE PharmacyQandilDB;
GO

PRINT '1. Testing Dashboard Stats:';
EXEC dbo.HR_Dashboard_Stats;

PRINT '2. Testing Employees:';
EXEC dbo.HR_Employees_SelectAll;

PRINT '3. Testing Today Attendance:';
EXEC dbo.HR_Attendance_SelectAll;

PRINT '4. Testing Shifts:';
EXEC dbo.HR_Shifts_SelectAll;

PRINT '5. Testing Leave Types:';
EXEC dbo.HR_LeaveTypes_SelectAll;

PRINT '6. Testing Leaves:';
EXEC dbo.HR_Leaves_SelectAll;

PRINT '7. Testing Payroll:';
EXEC dbo.HR_Payroll_SelectAll;

PRINT '8. Testing Places GPS:';
EXEC dbo.Places_GPS_SelectAll;
GO
