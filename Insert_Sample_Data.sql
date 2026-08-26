USE PharmacyQandilDB;
GO

-- 1. Sample Branches GPS
IF NOT EXISTS (SELECT 1 FROM dbo.tblPlaces_GPS WHERE Places_ID = 1)
BEGIN
    INSERT INTO dbo.tblPlaces_GPS (Places_ID, Latitude, Longitude, AllowedRadiusMeters, IsActive, Notes)
    VALUES (1, 35.565800, 45.421500, 50, 1, N'دەرمانخانەی قەندیل - لقی سەرەکی سەهۆڵەکە');
END

IF NOT EXISTS (SELECT 1 FROM dbo.tblPlaces_GPS WHERE Places_ID = 6)
BEGIN
    INSERT INTO dbo.tblPlaces_GPS (Places_ID, Latitude, Longitude, AllowedRadiusMeters, IsActive, Notes)
    VALUES (6, 35.558200, 45.438900, 50, 1, N'دەرمانخانەی قەندیل - لقی ناوەند');
END

IF NOT EXISTS (SELECT 1 FROM dbo.tblPlaces_GPS WHERE Places_ID = 8)
BEGIN
    INSERT INTO dbo.tblPlaces_GPS (Places_ID, Latitude, Longitude, AllowedRadiusMeters, IsActive, Notes)
    VALUES (8, 35.572100, 45.410200, 60, 1, N'دەرمانخانەی قەندیل - لقی لینا');
END
GO

-- 2. Sample Shifts
IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_Shifts WHERE ShiftName = N'شیفتی بەیانیان')
BEGIN
    INSERT INTO dbo.tblHR_Shifts (ShiftName, StartTime, EndTime, LateGraceMinutes, OvertimeStartMinutes, IsActive, Notes)
    VALUES 
    (N'شیفتی بەیانیان', N'08:00', N'16:00', 15, 30, 1, N'شیفتی ئاسایی بەیانیان بۆ دەرمانخانە'),
    (N'شیفتی ئێواران', N'16:00', N'00:00', 15, 30, 1, N'شیفتی دووەمی دەرمانخانە'),
    (N'شیفتی شەوانە (خەفارەت)', N'00:00', N'08:00', 20, 30, 1, N'شیفتی ئێشکگری شەوانە');
END
GO

-- 3. Sample Leave Types
IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_LeaveTypes WHERE TypeName = N'مۆڵەتی ئاسایی (ساڵانە)')
BEGIN
    INSERT INTO dbo.tblHR_LeaveTypes (TypeName, MaxDaysPerYear, IsPaid, IsActive)
    VALUES 
    (N'مۆڵەتی ئاسایی (ساڵانە)', 15, 1, 1),
    (N'مۆڵەتی نەخۆشی', 10, 1, 1),
    (N'مۆڵەتی بەپەلە', 5, 1, 1),
    (N'مۆڵەتی بێ مووچە', 30, 0, 1);
END
GO

-- 4. Sample Employees
IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_Employees WHERE FullName = N'د. ئاراس کەمال مەحموود')
BEGIN
    INSERT INTO dbo.tblHR_Employees (Places_ID, Job_ID, FullName, Phone, Email, NationalID, DeviceUUID, BaseSalary, HireDate, IsActive, Notes)
    VALUES 
    (1, 1, N'د. ئاراس کەمال مەحموود', N'07701234567', N'aras.kamal@pharmacyqandil.com', N'1990123456', N'DEV-SAMSUNG-S23-001', 950000.00, '2023-01-15', 1, N'دەرمانسازی بەرپرسی لقی سەرەکی'),
    (1, 2, N'لانە ئەحمەد حەسەن', N'07502345678', N'lana.ahmed@pharmacyqandil.com', N'1994234567', N'DEV-IPHONE-15-002', 750000.00, '2023-05-10', 1, N'یاریدەدەری دەرمانساز'),
    (6, 1, N'د. ڕێبین عەلی قادر', N'07703456789', N'rebin.ali@pharmacyqandil.com', N'1992345678', N'DEV-XIAOMI-13-003', 900000.00, '2023-08-01', 1, N'دەرمانسازی بەرپرسی لقی ناوەند'),
    (6, 3, N'سازگار محەمەد عەزیز', N'07504567890', N'sazgar.m@pharmacyqandil.com', N'1996456789', N'DEV-IPHONE-14-004', 600000.00, '2024-01-10', 1, N'موحاسیبی دەرمانخانە'),
    (8, 2, N'دیاری عوسمان حەمە', N'07705678901', N'diyari.o@pharmacyqandil.com', N'1995567890', N'DEV-HUAWEI-P60-005', 650000.00, '2024-03-01', 1, N'یاریدەدەری دەرمانساز و کۆگا');
END
GO

-- 5. Sample Employee Shifts for Today
DECLARE @Emp1 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'د. ئاراس کەمال مەحموود');
DECLARE @Emp2 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'لانە ئەحمەد حەسەن');
DECLARE @Emp3 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'د. ڕێبین عەلی قادر');
DECLARE @Emp4 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'سازگار محەمەد عەزیز');
DECLARE @ShiftMorning INT = (SELECT TOP 1 Shift_ID FROM dbo.tblHR_Shifts WHERE ShiftName = N'شیفتی بەیانیان');
DECLARE @ShiftEvening INT = (SELECT TOP 1 Shift_ID FROM dbo.tblHR_Shifts WHERE ShiftName = N'شیفتی ئێواران');

IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_EmployeeShifts WHERE ShiftDate = CONVERT(date, GETDATE()))
BEGIN
    INSERT INTO dbo.tblHR_EmployeeShifts (Emp_ID, Shift_ID, ShiftDate, Places_ID, IsApproved)
    VALUES 
    (@Emp1, @ShiftMorning, CONVERT(date, GETDATE()), 1, 1),
    (@Emp2, @ShiftMorning, CONVERT(date, GETDATE()), 1, 1),
    (@Emp3, @ShiftEvening, CONVERT(date, GETDATE()), 6, 1),
    (@Emp4, @ShiftEvening, CONVERT(date, GETDATE()), 6, 1);
END
GO

-- 6. Sample Attendance Logs for Today (with Selfie placeholders)
DECLARE @Emp1 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'د. ئاراس کەمال مەحموود');
DECLARE @Emp2 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'لانە ئەحمەد حەسەن');

IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_Attendance WHERE CONVERT(date, CheckDateTime) = CONVERT(date, GETDATE()))
BEGIN
    INSERT INTO dbo.tblHR_Attendance (Emp_ID, Place_ID, CheckType, CheckDateTime, Latitude, Longitude, DistanceMeters, SelfieImagePath, DeviceUUID, Status, Notes)
    VALUES 
    (@Emp1, 1, 1, DATEADD(minute, -180, GETDATE()), 35.565812, 45.421510, 8.5, N'Uploads/AttendanceSelfies/sample_selfie_1.jpg', N'DEV-SAMSUNG-S23-001', 1, N'دەوامی سەرەتای بەیانی - لە کاتی خۆیدا'),
    (@Emp2, 1, 1, DATEADD(minute, -165, GETDATE()), 35.565825, 45.421530, 12.0, N'Uploads/AttendanceSelfies/sample_selfie_2.jpg', N'DEV-IPHONE-15-002', 2, N'١٥ خولەک دواکەوتووە بەهۆی قەرەباڵغی');
END
GO

-- 7. Sample Leaves
DECLARE @Emp3 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'د. ڕێبین عەلی قادر');
DECLARE @LeaveType1 INT = (SELECT TOP 1 LeaveType_ID FROM dbo.tblHR_LeaveTypes WHERE TypeName LIKE N'%ئاسایی%');
DECLARE @LeaveType2 INT = (SELECT TOP 1 LeaveType_ID FROM dbo.tblHR_LeaveTypes WHERE TypeName LIKE N'%نەخۆشی%');

IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_Leaves)
BEGIN
    INSERT INTO dbo.tblHR_Leaves (Emp_ID, LeaveType_ID, StartDate, EndDate, TotalDays, Reason, Status, ApprovedBy)
    VALUES 
    (@Emp3, @LeaveType1, DATEADD(day, 3, CONVERT(date, GETDATE())), DATEADD(day, 4, CONVERT(date, GETDATE())), 2.0, N'مۆڵەتی بەشداری کۆنفرانسی پزیشکی دەرمانسازان', 2, 1),
    (@Emp3, @LeaveType2, DATEADD(day, 10, CONVERT(date, GETDATE())), DATEADD(day, 10, CONVERT(date, GETDATE())), 1.0, N'مۆڵەتی سەردانی پزیشک', 1, NULL);
END
GO

-- 8. Sample Deductions & Rewards
DECLARE @Emp1 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'د. ئاراس کەمال مەحموود');
DECLARE @Emp2 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'لانە ئەحمەد حەسەن');

IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_Deductions_Rewards)
BEGIN
    INSERT INTO dbo.tblHR_Deductions_Rewards (Emp_ID, TransType, Amount, Reason, TransDate)
    VALUES 
    (@Emp1, 1, 50000.00, N'پاداشتی دەوامی کاتی ئێشکگری و سەرکەوتوویی لە فرۆش', CONVERT(date, GETDATE())),
    (@Emp2, 2, 15000.00, N'بڕینی سزا بەهۆی دواکەوتنی دووبارە لە شیفت', CONVERT(date, GETDATE()));
END
GO

-- 9. Sample Payroll
DECLARE @Emp1 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'د. ئاراس کەمال مەحموود');
DECLARE @Emp2 INT = (SELECT TOP 1 Emp_ID FROM dbo.tblHR_Employees WHERE FullName = N'لانە ئەحمەد حەسەن');

IF NOT EXISTS (SELECT 1 FROM dbo.tblHR_Payroll)
BEGIN
    INSERT INTO dbo.tblHR_Payroll (Emp_ID, YearNo, MonthNo, BaseSalary, TotalDaysPresent, TotalHoursWorked, OvertimeAmount, RewardAmount, DeductionAmount, NetSalary, IsPaid, PaymentDate, Notes)
    VALUES 
    (@Emp1, 2026, 7, 950000.00, 26, 208.00, 60000.00, 50000.00, 0.00, 1060000.00, 1, '2026-08-01', N'مووچەی مانگی ٧ دراوە بە تەواوی'),
    (@Emp2, 2026, 7, 750000.00, 25, 200.00, 30000.00, 0.00, 15000.00, 765000.00, 1, '2026-08-01', N'مووچەی مانگی ٧ دراوە');
END
GO
