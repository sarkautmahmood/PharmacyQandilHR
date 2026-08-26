-- ==========================================================
-- PharmacyQandilHR Database Schema & Stored Procedures
-- Database: PharmacyQandilDB
-- ==========================================================
USE PharmacyQandilDB;
GO

-- 1. Table: tblPlaces_GPS
IF OBJECT_ID('dbo.tblPlaces_GPS', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblPlaces_GPS (
        Places_GPS_ID INT IDENTITY(1,1) PRIMARY KEY,
        Places_ID INT NOT NULL,
        Latitude FLOAT NOT NULL,
        Longitude FLOAT NOT NULL,
        AllowedRadiusMeters INT DEFAULT 50,
        IsActive TINYINT DEFAULT 1,
        Notes NVARCHAR(500) NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 2. Table: tblHR_Employees
IF OBJECT_ID('dbo.tblHR_Employees', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_Employees (
        Emp_ID INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NULL,
        Places_ID INT NOT NULL,
        Job_ID SMALLINT NULL,
        FullName NVARCHAR(250) NOT NULL,
        Phone NVARCHAR(50) NULL,
        Email NVARCHAR(150) NULL,
        NationalID NVARCHAR(50) NULL,
        DeviceUUID NVARCHAR(250) NULL,
        BaseSalary DECIMAL(18,2) DEFAULT 0,
        HireDate DATE NULL,
        IsActive TINYINT DEFAULT 1,
        Notes NVARCHAR(500) NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 3. Table: tblHR_Shifts
IF OBJECT_ID('dbo.tblHR_Shifts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_Shifts (
        Shift_ID INT IDENTITY(1,1) PRIMARY KEY,
        ShiftName NVARCHAR(150) NOT NULL,
        StartTime NVARCHAR(10) NOT NULL,
        EndTime NVARCHAR(10) NOT NULL,
        LateGraceMinutes INT DEFAULT 15,
        OvertimeStartMinutes INT DEFAULT 30,
        IsActive TINYINT DEFAULT 1,
        Notes NVARCHAR(500) NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 4. Table: tblHR_EmployeeShifts
IF OBJECT_ID('dbo.tblHR_EmployeeShifts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_EmployeeShifts (
        EmpShift_ID INT IDENTITY(1,1) PRIMARY KEY,
        Emp_ID INT NOT NULL,
        Shift_ID INT NOT NULL,
        ShiftDate DATE NOT NULL,
        Places_ID INT NOT NULL,
        IsApproved TINYINT DEFAULT 1,
        Notes NVARCHAR(500) NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 5. Table: tblHR_Attendance
IF OBJECT_ID('dbo.tblHR_Attendance', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_Attendance (
        Attendance_ID INT IDENTITY(1,1) PRIMARY KEY,
        Emp_ID INT NOT NULL,
        Place_ID INT NOT NULL,
        CheckType TINYINT NOT NULL, -- 1: In, 2: Out
        CheckDateTime DATETIME NOT NULL DEFAULT GETDATE(),
        Latitude FLOAT NOT NULL,
        Longitude FLOAT NOT NULL,
        DistanceMeters FLOAT NOT NULL,
        SelfieImagePath NVARCHAR(500) NOT NULL,
        DeviceUUID NVARCHAR(250) NOT NULL,
        Status TINYINT DEFAULT 1, -- 1: OnTime, 2: Late, 3: EarlyLeave, 4: Overtime, 5: Rejected
        Notes NVARCHAR(500) NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 6. Table: tblHR_LeaveTypes
IF OBJECT_ID('dbo.tblHR_LeaveTypes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_LeaveTypes (
        LeaveType_ID INT IDENTITY(1,1) PRIMARY KEY,
        TypeName NVARCHAR(150) NOT NULL,
        MaxDaysPerYear INT DEFAULT 15,
        IsPaid TINYINT DEFAULT 1,
        IsActive TINYINT DEFAULT 1,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 7. Table: tblHR_Leaves
IF OBJECT_ID('dbo.tblHR_Leaves', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_Leaves (
        Leave_ID INT IDENTITY(1,1) PRIMARY KEY,
        Emp_ID INT NOT NULL,
        LeaveType_ID INT NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        TotalDays DECIMAL(5,2) DEFAULT 1,
        Reason NVARCHAR(500) NULL,
        Status TINYINT DEFAULT 1, -- 1: Pending, 2: Approved, 3: Rejected
        ApprovedBy INT NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 8. Table: tblHR_Deductions_Rewards
IF OBJECT_ID('dbo.tblHR_Deductions_Rewards', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_Deductions_Rewards (
        Trans_ID INT IDENTITY(1,1) PRIMARY KEY,
        Emp_ID INT NOT NULL,
        TransType TINYINT NOT NULL, -- 1: Reward, 2: Deduction, 3: Advance
        Amount DECIMAL(18,2) NOT NULL,
        Reason NVARCHAR(500) NOT NULL,
        TransDate DATE NOT NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- 9. Table: tblHR_Payroll
IF OBJECT_ID('dbo.tblHR_Payroll', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblHR_Payroll (
        Payroll_ID INT IDENTITY(1,1) PRIMARY KEY,
        Emp_ID INT NOT NULL,
        YearNo INT NOT NULL,
        MonthNo INT NOT NULL,
        BaseSalary DECIMAL(18,2) NOT NULL,
        TotalDaysPresent INT DEFAULT 0,
        TotalHoursWorked DECIMAL(10,2) DEFAULT 0,
        OvertimeAmount DECIMAL(18,2) DEFAULT 0,
        RewardAmount DECIMAL(18,2) DEFAULT 0,
        DeductionAmount DECIMAL(18,2) DEFAULT 0,
        NetSalary DECIMAL(18,2) NOT NULL,
        IsPaid TINYINT DEFAULT 0,
        PaymentDate DATETIME NULL,
        Notes NVARCHAR(500) NULL,
        user_insert INT DEFAULT 1,
        user_update INT DEFAULT 1,
        date_insert DATETIME DEFAULT GETDATE(),
        date_update DATETIME DEFAULT GETDATE()
    );
END
GO

-- =========================================================================
-- STORED PROCEDURES (5 SPs per table adhering strictly to standards)
-- =========================================================================

-- -------------------------------------------------------------
-- tblPlaces_GPS Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.Places_GPS_Insert
    @user_insert int = 1,
    @Places_ID int,
    @Latitude float,
    @Longitude float,
    @AllowedRadiusMeters int = 50,
    @IsActive tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblPlaces_GPS
        (Places_ID, Latitude, Longitude, AllowedRadiusMeters, IsActive, Notes, user_insert, user_update, date_insert, date_update)
        VALUES
        (@Places_ID, @Latitude, @Longitude, @AllowedRadiusMeters, @IsActive, @Notes, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'Places_GPS_Insert', ERROR_LINE(), 'Places_GPS_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.Places_GPS_Update
    @Places_GPS_ID int,
    @user_update int = 1,
    @Places_ID int,
    @Latitude float,
    @Longitude float,
    @AllowedRadiusMeters int = 50,
    @IsActive tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblPlaces_GPS
        SET Places_ID = @Places_ID,
            Latitude = @Latitude,
            Longitude = @Longitude,
            AllowedRadiusMeters = @AllowedRadiusMeters,
            IsActive = @IsActive,
            Notes = @Notes,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Places_GPS_ID = @Places_GPS_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'Places_GPS_Update', ERROR_LINE(), 'Places_GPS_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.Places_GPS_delete
    @Places_GPS_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblPlaces_GPS WHERE Places_GPS_ID = @Places_GPS_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'Places_GPS_delete', ERROR_LINE(), 'Places_GPS_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.Places_GPS_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT g.*, p.Places_Name 
    FROM dbo.tblPlaces_GPS g
    LEFT JOIN dbo.tblPlaces p ON g.Places_ID = p.Places_ID
    ORDER BY g.Places_GPS_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.Places_GPS_selectID
    @Places_GPS_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT g.*, p.Places_Name 
    FROM dbo.tblPlaces_GPS g
    LEFT JOIN dbo.tblPlaces p ON g.Places_ID = p.Places_ID
    WHERE g.Places_GPS_ID = @Places_GPS_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_Employees Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Employees_Insert
    @user_insert int = 1,
    @UserId int = NULL,
    @Places_ID int,
    @Job_ID smallint = NULL,
    @FullName nvarchar(250),
    @Phone nvarchar(50) = NULL,
    @Email nvarchar(150) = NULL,
    @NationalID nvarchar(50) = NULL,
    @DeviceUUID nvarchar(250) = NULL,
    @BaseSalary decimal(18,2) = 0,
    @HireDate date = NULL,
    @IsActive tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_Employees
        (UserId, Places_ID, Job_ID, FullName, Phone, Email, NationalID, DeviceUUID, BaseSalary, HireDate, IsActive, Notes, user_insert, user_update, date_insert, date_update)
        VALUES
        (@UserId, @Places_ID, @Job_ID, @FullName, @Phone, @Email, @NationalID, @DeviceUUID, @BaseSalary, @HireDate, @IsActive, @Notes, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Employees_Insert', ERROR_LINE(), 'HR_Employees_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Employees_Update
    @Emp_ID int,
    @user_update int = 1,
    @UserId int = NULL,
    @Places_ID int,
    @Job_ID smallint = NULL,
    @FullName nvarchar(250),
    @Phone nvarchar(50) = NULL,
    @Email nvarchar(150) = NULL,
    @NationalID nvarchar(50) = NULL,
    @DeviceUUID nvarchar(250) = NULL,
    @BaseSalary decimal(18,2) = 0,
    @HireDate date = NULL,
    @IsActive tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_Employees
        SET UserId = @UserId,
            Places_ID = @Places_ID,
            Job_ID = @Job_ID,
            FullName = @FullName,
            Phone = @Phone,
            Email = @Email,
            NationalID = @NationalID,
            DeviceUUID = @DeviceUUID,
            BaseSalary = @BaseSalary,
            HireDate = @HireDate,
            IsActive = @IsActive,
            Notes = @Notes,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Emp_ID = @Emp_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Employees_Update', ERROR_LINE(), 'HR_Employees_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Employees_delete
    @Emp_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_Employees WHERE Emp_ID = @Emp_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Employees_delete', ERROR_LINE(), 'HR_Employees_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Employees_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT e.*, p.Places_Name, j.JobTitle_Name
    FROM dbo.tblHR_Employees e
    LEFT JOIN dbo.tblPlaces p ON e.Places_ID = p.Places_ID
    LEFT JOIN dbo.tblUserJobTitle j ON e.Job_ID = j.JobTitle_ID
    ORDER BY e.Emp_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Employees_selectID
    @Emp_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT e.*, p.Places_Name, j.JobTitle_Name
    FROM dbo.tblHR_Employees e
    LEFT JOIN dbo.tblPlaces p ON e.Places_ID = p.Places_ID
    LEFT JOIN dbo.tblUserJobTitle j ON e.Job_ID = j.JobTitle_ID
    WHERE e.Emp_ID = @Emp_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_Shifts Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Shifts_Insert
    @user_insert int = 1,
    @ShiftName nvarchar(150),
    @StartTime nvarchar(10),
    @EndTime nvarchar(10),
    @LateGraceMinutes int = 15,
    @OvertimeStartMinutes int = 30,
    @IsActive tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_Shifts
        (ShiftName, StartTime, EndTime, LateGraceMinutes, OvertimeStartMinutes, IsActive, Notes, user_insert, user_update, date_insert, date_update)
        VALUES
        (@ShiftName, @StartTime, @EndTime, @LateGraceMinutes, @OvertimeStartMinutes, @IsActive, @Notes, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Shifts_Insert', ERROR_LINE(), 'HR_Shifts_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Shifts_Update
    @Shift_ID int,
    @user_update int = 1,
    @ShiftName nvarchar(150),
    @StartTime nvarchar(10),
    @EndTime nvarchar(10),
    @LateGraceMinutes int = 15,
    @OvertimeStartMinutes int = 30,
    @IsActive tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_Shifts
        SET ShiftName = @ShiftName,
            StartTime = @StartTime,
            EndTime = @EndTime,
            LateGraceMinutes = @LateGraceMinutes,
            OvertimeStartMinutes = @OvertimeStartMinutes,
            IsActive = @IsActive,
            Notes = @Notes,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Shift_ID = @Shift_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Shifts_Update', ERROR_LINE(), 'HR_Shifts_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Shifts_delete
    @Shift_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_Shifts WHERE Shift_ID = @Shift_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Shifts_delete', ERROR_LINE(), 'HR_Shifts_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Shifts_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.tblHR_Shifts ORDER BY Shift_ID ASC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Shifts_selectID
    @Shift_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.tblHR_Shifts WHERE Shift_ID = @Shift_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_EmployeeShifts Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_EmployeeShifts_Insert
    @user_insert int = 1,
    @Emp_ID int,
    @Shift_ID int,
    @ShiftDate date,
    @Places_ID int,
    @IsApproved tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_EmployeeShifts
        (Emp_ID, Shift_ID, ShiftDate, Places_ID, IsApproved, Notes, user_insert, user_update, date_insert, date_update)
        VALUES
        (@Emp_ID, @Shift_ID, @ShiftDate, @Places_ID, @IsApproved, @Notes, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_EmployeeShifts_Insert', ERROR_LINE(), 'HR_EmployeeShifts_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_EmployeeShifts_Update
    @EmpShift_ID int,
    @user_update int = 1,
    @Emp_ID int,
    @Shift_ID int,
    @ShiftDate date,
    @Places_ID int,
    @IsApproved tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_EmployeeShifts
        SET Emp_ID = @Emp_ID,
            Shift_ID = @Shift_ID,
            ShiftDate = @ShiftDate,
            Places_ID = @Places_ID,
            IsApproved = @IsApproved,
            Notes = @Notes,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE EmpShift_ID = @EmpShift_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_EmployeeShifts_Update', ERROR_LINE(), 'HR_EmployeeShifts_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_EmployeeShifts_delete
    @EmpShift_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_EmployeeShifts WHERE EmpShift_ID = @EmpShift_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_EmployeeShifts_delete', ERROR_LINE(), 'HR_EmployeeShifts_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_EmployeeShifts_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT es.*, e.FullName, s.ShiftName, s.StartTime, s.EndTime, p.Places_Name
    FROM dbo.tblHR_EmployeeShifts es
    LEFT JOIN dbo.tblHR_Employees e ON es.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblHR_Shifts s ON es.Shift_ID = s.Shift_ID
    LEFT JOIN dbo.tblPlaces p ON es.Places_ID = p.Places_ID
    ORDER BY es.ShiftDate DESC, es.EmpShift_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_EmployeeShifts_selectID
    @EmpShift_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT es.*, e.FullName, s.ShiftName, s.StartTime, s.EndTime, p.Places_Name
    FROM dbo.tblHR_EmployeeShifts es
    LEFT JOIN dbo.tblHR_Employees e ON es.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblHR_Shifts s ON es.Shift_ID = s.Shift_ID
    LEFT JOIN dbo.tblPlaces p ON es.Places_ID = p.Places_ID
    WHERE es.EmpShift_ID = @EmpShift_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_Attendance Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Attendance_Insert
    @user_insert int = 1,
    @Emp_ID int,
    @Place_ID int,
    @CheckType tinyint,
    @CheckDateTime datetime = NULL,
    @Latitude float,
    @Longitude float,
    @DistanceMeters float,
    @SelfieImagePath nvarchar(500),
    @DeviceUUID nvarchar(250),
    @Status tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @CheckDateTime IS NULL SET @CheckDateTime = GETDATE();
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_Attendance
        (Emp_ID, Place_ID, CheckType, CheckDateTime, Latitude, Longitude, DistanceMeters, SelfieImagePath, DeviceUUID, Status, Notes, user_insert, user_update, date_insert, date_update)
        VALUES
        (@Emp_ID, @Place_ID, @CheckType, @CheckDateTime, @Latitude, @Longitude, @DistanceMeters, @SelfieImagePath, @DeviceUUID, @Status, @Notes, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Attendance_Insert', ERROR_LINE(), 'HR_Attendance_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Attendance_Update
    @Attendance_ID int,
    @user_update int = 1,
    @Emp_ID int,
    @Place_ID int,
    @CheckType tinyint,
    @CheckDateTime datetime,
    @Latitude float,
    @Longitude float,
    @DistanceMeters float,
    @SelfieImagePath nvarchar(500),
    @DeviceUUID nvarchar(250),
    @Status tinyint = 1,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_Attendance
        SET Emp_ID = @Emp_ID,
            Place_ID = @Place_ID,
            CheckType = @CheckType,
            CheckDateTime = @CheckDateTime,
            Latitude = @Latitude,
            Longitude = @Longitude,
            DistanceMeters = @DistanceMeters,
            SelfieImagePath = @SelfieImagePath,
            DeviceUUID = @DeviceUUID,
            Status = @Status,
            Notes = @Notes,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Attendance_ID = @Attendance_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Attendance_Update', ERROR_LINE(), 'HR_Attendance_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Attendance_delete
    @Attendance_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_Attendance WHERE Attendance_ID = @Attendance_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Attendance_delete', ERROR_LINE(), 'HR_Attendance_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Attendance_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.*, e.FullName, p.Places_Name
    FROM dbo.tblHR_Attendance a
    LEFT JOIN dbo.tblHR_Employees e ON a.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblPlaces p ON a.Place_ID = p.Places_ID
    ORDER BY a.CheckDateTime DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Attendance_selectID
    @Attendance_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.*, e.FullName, p.Places_Name
    FROM dbo.tblHR_Attendance a
    LEFT JOIN dbo.tblHR_Employees e ON a.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblPlaces p ON a.Place_ID = p.Places_ID
    WHERE a.Attendance_ID = @Attendance_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_LeaveTypes Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_LeaveTypes_Insert
    @user_insert int = 1,
    @TypeName nvarchar(150),
    @MaxDaysPerYear int = 15,
    @IsPaid tinyint = 1,
    @IsActive tinyint = 1,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_LeaveTypes
        (TypeName, MaxDaysPerYear, IsPaid, IsActive, user_insert, user_update, date_insert, date_update)
        VALUES
        (@TypeName, @MaxDaysPerYear, @IsPaid, @IsActive, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_LeaveTypes_Insert', ERROR_LINE(), 'HR_LeaveTypes_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_LeaveTypes_Update
    @LeaveType_ID int,
    @user_update int = 1,
    @TypeName nvarchar(150),
    @MaxDaysPerYear int = 15,
    @IsPaid tinyint = 1,
    @IsActive tinyint = 1,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_LeaveTypes
        SET TypeName = @TypeName,
            MaxDaysPerYear = @MaxDaysPerYear,
            IsPaid = @IsPaid,
            IsActive = @IsActive,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE LeaveType_ID = @LeaveType_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_LeaveTypes_Update', ERROR_LINE(), 'HR_LeaveTypes_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_LeaveTypes_delete
    @LeaveType_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_LeaveTypes WHERE LeaveType_ID = @LeaveType_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_LeaveTypes_delete', ERROR_LINE(), 'HR_LeaveTypes_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_LeaveTypes_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.tblHR_LeaveTypes ORDER BY LeaveType_ID ASC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_LeaveTypes_selectID
    @LeaveType_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.tblHR_LeaveTypes WHERE LeaveType_ID = @LeaveType_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_Leaves Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Leaves_Insert
    @user_insert int = 1,
    @Emp_ID int,
    @LeaveType_ID int,
    @StartDate date,
    @EndDate date,
    @TotalDays decimal(5,2) = 1,
    @Reason nvarchar(500) = NULL,
    @Status tinyint = 1,
    @ApprovedBy int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_Leaves
        (Emp_ID, LeaveType_ID, StartDate, EndDate, TotalDays, Reason, Status, ApprovedBy, user_insert, user_update, date_insert, date_update)
        VALUES
        (@Emp_ID, @LeaveType_ID, @StartDate, @EndDate, @TotalDays, @Reason, @Status, @ApprovedBy, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Leaves_Insert', ERROR_LINE(), 'HR_Leaves_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Leaves_Update
    @Leave_ID int,
    @user_update int = 1,
    @Emp_ID int,
    @LeaveType_ID int,
    @StartDate date,
    @EndDate date,
    @TotalDays decimal(5,2) = 1,
    @Reason nvarchar(500) = NULL,
    @Status tinyint = 1,
    @ApprovedBy int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_Leaves
        SET Emp_ID = @Emp_ID,
            LeaveType_ID = @LeaveType_ID,
            StartDate = @StartDate,
            EndDate = @EndDate,
            TotalDays = @TotalDays,
            Reason = @Reason,
            Status = @Status,
            ApprovedBy = @ApprovedBy,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Leave_ID = @Leave_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Leaves_Update', ERROR_LINE(), 'HR_Leaves_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Leaves_delete
    @Leave_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_Leaves WHERE Leave_ID = @Leave_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Leaves_delete', ERROR_LINE(), 'HR_Leaves_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Leaves_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT l.*, e.FullName, lt.TypeName 
    FROM dbo.tblHR_Leaves l
    LEFT JOIN dbo.tblHR_Employees e ON l.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblHR_LeaveTypes lt ON l.LeaveType_ID = lt.LeaveType_ID
    ORDER BY l.Leave_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Leaves_selectID
    @Leave_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT l.*, e.FullName, lt.TypeName 
    FROM dbo.tblHR_Leaves l
    LEFT JOIN dbo.tblHR_Employees e ON l.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblHR_LeaveTypes lt ON l.LeaveType_ID = lt.LeaveType_ID
    WHERE l.Leave_ID = @Leave_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_Deductions_Rewards Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Deductions_Rewards_Insert
    @user_insert int = 1,
    @Emp_ID int,
    @TransType tinyint,
    @Amount decimal(18,2),
    @Reason nvarchar(500),
    @TransDate date,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_Deductions_Rewards
        (Emp_ID, TransType, Amount, Reason, TransDate, user_insert, user_update, date_insert, date_update)
        VALUES
        (@Emp_ID, @TransType, @Amount, @Reason, @TransDate, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Deductions_Rewards_Insert', ERROR_LINE(), 'HR_Deductions_Rewards_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Deductions_Rewards_Update
    @Trans_ID int,
    @user_update int = 1,
    @Emp_ID int,
    @TransType tinyint,
    @Amount decimal(18,2),
    @Reason nvarchar(500),
    @TransDate date,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_Deductions_Rewards
        SET Emp_ID = @Emp_ID,
            TransType = @TransType,
            Amount = @Amount,
            Reason = @Reason,
            TransDate = @TransDate,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Trans_ID = @Trans_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Deductions_Rewards_Update', ERROR_LINE(), 'HR_Deductions_Rewards_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Deductions_Rewards_delete
    @Trans_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_Deductions_Rewards WHERE Trans_ID = @Trans_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Deductions_Rewards_delete', ERROR_LINE(), 'HR_Deductions_Rewards_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Deductions_Rewards_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.*, e.FullName 
    FROM dbo.tblHR_Deductions_Rewards r
    LEFT JOIN dbo.tblHR_Employees e ON r.Emp_ID = e.Emp_ID
    ORDER BY r.Trans_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Deductions_Rewards_selectID
    @Trans_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.*, e.FullName 
    FROM dbo.tblHR_Deductions_Rewards r
    LEFT JOIN dbo.tblHR_Employees e ON r.Emp_ID = e.Emp_ID
    WHERE r.Trans_ID = @Trans_ID;
END
GO

-- -------------------------------------------------------------
-- tblHR_Payroll Procs
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Payroll_Insert
    @user_insert int = 1,
    @Emp_ID int,
    @YearNo int,
    @MonthNo int,
    @BaseSalary decimal(18,2),
    @TotalDaysPresent int = 0,
    @TotalHoursWorked decimal(10,2) = 0,
    @OvertimeAmount decimal(18,2) = 0,
    @RewardAmount decimal(18,2) = 0,
    @DeductionAmount decimal(18,2) = 0,
    @NetSalary decimal(18,2),
    @IsPaid tinyint = 0,
    @PaymentDate datetime = NULL,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO dbo.tblHR_Payroll
        (Emp_ID, YearNo, MonthNo, BaseSalary, TotalDaysPresent, TotalHoursWorked, OvertimeAmount, RewardAmount, DeductionAmount, NetSalary, IsPaid, PaymentDate, Notes, user_insert, user_update, date_insert, date_update)
        VALUES
        (@Emp_ID, @YearNo, @MonthNo, @BaseSalary, @TotalDaysPresent, @TotalHoursWorked, @OvertimeAmount, @RewardAmount, @DeductionAmount, @NetSalary, @IsPaid, @PaymentDate, @Notes, @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Payroll_Insert', ERROR_LINE(), 'HR_Payroll_Insert', @user_insert, @user_insert, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Payroll_Update
    @Payroll_ID int,
    @user_update int = 1,
    @Emp_ID int,
    @YearNo int,
    @MonthNo int,
    @BaseSalary decimal(18,2),
    @TotalDaysPresent int = 0,
    @TotalHoursWorked decimal(10,2) = 0,
    @OvertimeAmount decimal(18,2) = 0,
    @RewardAmount decimal(18,2) = 0,
    @DeductionAmount decimal(18,2) = 0,
    @NetSalary decimal(18,2),
    @IsPaid tinyint = 0,
    @PaymentDate datetime = NULL,
    @Notes nvarchar(500) = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        UPDATE dbo.tblHR_Payroll
        SET Emp_ID = @Emp_ID,
            YearNo = @YearNo,
            MonthNo = @MonthNo,
            BaseSalary = @BaseSalary,
            TotalDaysPresent = @TotalDaysPresent,
            TotalHoursWorked = @TotalHoursWorked,
            OvertimeAmount = @OvertimeAmount,
            RewardAmount = @RewardAmount,
            DeductionAmount = @DeductionAmount,
            NetSalary = @NetSalary,
            IsPaid = @IsPaid,
            PaymentDate = @PaymentDate,
            Notes = @Notes,
            user_update = @user_update,
            date_update = GETDATE()
        WHERE Payroll_ID = @Payroll_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Payroll_Update', ERROR_LINE(), 'HR_Payroll_Update', @user_update, @user_update, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Payroll_delete
    @Payroll_ID int,
    @user_delete int = 1,
    @Places_Fkey int = NULL,
    @ErrorMessage varchar(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM dbo.tblHR_Payroll WHERE Payroll_ID = @Payroll_ID;
        SET @ErrorMessage = '1';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        INSERT INTO dbo.tblSettingErrorMsg
        (ErrorMessage, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, MsgVoucherType, user_insert, user_update, date_insert, date_update)
        VALUES
        (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), 'HR_Payroll_delete', ERROR_LINE(), 'HR_Payroll_delete', @user_delete, @user_delete, GETDATE(), GETDATE());
        SET @ErrorMessage = '-1';
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Payroll_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.*, e.FullName, pl.Places_Name
    FROM dbo.tblHR_Payroll p
    LEFT JOIN dbo.tblHR_Employees e ON p.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblPlaces pl ON e.Places_ID = pl.Places_ID
    ORDER BY p.YearNo DESC, p.MonthNo DESC, p.Payroll_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.HR_Payroll_selectID
    @Payroll_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.*, e.FullName, pl.Places_Name
    FROM dbo.tblHR_Payroll p
    LEFT JOIN dbo.tblHR_Employees e ON p.Emp_ID = e.Emp_ID
    LEFT JOIN dbo.tblPlaces pl ON e.Places_ID = pl.Places_ID
    WHERE p.Payroll_ID = @Payroll_ID;
END
GO

-- -------------------------------------------------------------
-- Dashboard & Summary Helper Procedures
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.HR_Dashboard_Stats
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalEmployees int = (SELECT COUNT(*) FROM dbo.tblHR_Employees WHERE IsActive = 1);
    DECLARE @TodayAttendance int = (SELECT COUNT(DISTINCT Emp_ID) FROM dbo.tblHR_Attendance WHERE CONVERT(date, CheckDateTime) = CONVERT(date, GETDATE()) AND CheckType = 1);
    DECLARE @PendingLeaves int = (SELECT COUNT(*) FROM dbo.tblHR_Leaves WHERE Status = 1);
    DECLARE @TotalBranches int = (SELECT COUNT(*) FROM dbo.tblPlaces_GPS WHERE IsActive = 1);

    SELECT 
        @TotalEmployees AS TotalEmployees,
        @TodayAttendance AS TodayAttendance,
        @PendingLeaves AS PendingLeaves,
        @TotalBranches AS TotalBranches;
END
GO
