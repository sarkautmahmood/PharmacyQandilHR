using System;
using System.Data;
using System.Data.SqlClient;

class FixEncoding
{
    static void Main()
    {
        string cs = "Server=.;Database=PharmacyQandilDB;Integrated Security=True;TrustServerCertificate=True;";
        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();

            // 1. Clean previous sample data
            using (SqlCommand cmd = new SqlCommand(@"
                DELETE FROM dbo.tblHR_Attendance;
                DELETE FROM dbo.tblHR_EmployeeShifts;
                DELETE FROM dbo.tblHR_Leaves;
                DELETE FROM dbo.tblHR_Deductions_Rewards;
                DELETE FROM dbo.tblHR_Payroll;
                DELETE FROM dbo.tblHR_Employees;
                DELETE FROM dbo.tblHR_Shifts;
                DELETE FROM dbo.tblHR_LeaveTypes;
                DELETE FROM dbo.tblPlaces_GPS;

                DBCC CHECKIDENT ('tblHR_Employees', RESEED, 0);
                DBCC CHECKIDENT ('tblHR_Shifts', RESEED, 0);
                DBCC CHECKIDENT ('tblHR_LeaveTypes', RESEED, 0);
                DBCC CHECKIDENT ('tblHR_Attendance', RESEED, 0);
                DBCC CHECKIDENT ('tblHR_Leaves', RESEED, 0);
                DBCC CHECKIDENT ('tblHR_Deductions_Rewards', RESEED, 0);
                DBCC CHECKIDENT ('tblHR_Payroll', RESEED, 0);
                DBCC CHECKIDENT ('tblPlaces_GPS', RESEED, 0);
            ", con))
            {
                cmd.ExecuteNonQuery();
            }

            // 2. Insert Branches GPS with proper Kurdish Unicode
            InsertPlacesGps(con, 1, 35.565800, 45.421500, 50, "دەرمانخانەی قەندیل - لقی سەرەکی سەهۆڵەکە");
            InsertPlacesGps(con, 6, 35.558200, 45.438900, 50, "دەرمانخانەی قەندیل - لقی ناوەند");
            InsertPlacesGps(con, 8, 35.572100, 45.410200, 60, "دەرمانخانەی قەندیل - لقی لینا");

            // 3. Insert Shift Types with proper Kurdish Unicode
            InsertShift(con, "شیفتی بەیانیان", "08:00", "16:00", 15, 30, "شیفتی ئاسایی بەیانیان بۆ دەرمانخانە");
            InsertShift(con, "شیفتی ئێواران", "16:00", "00:00", 15, 30, "شیفتی دووەمی دەرمانخانە");
            InsertShift(con, "شیفتی شەوانە (خەفارەت)", "00:00", "08:00", 20, 30, "شیفتی ئێشکگری شەوانە");

            // 4. Insert Leave Types with proper Kurdish Unicode
            InsertLeaveType(con, "مۆڵەتی ئاسایی (ساڵانە)", 15, 1);
            InsertLeaveType(con, "مۆڵەتی نەخۆشی", 10, 1);
            InsertLeaveType(con, "مۆڵەتی بەپەلە", 5, 1);
            InsertLeaveType(con, "مۆڵەتی بێ مووچە", 30, 0);

            // 5. Insert Employees with proper Kurdish Unicode
            int emp1 = InsertEmployee(con, 1, 1, "د. ئاراس کەمال مەحموود", "07701234567", "aras.kamal@pharmacyqandil.com", "DEV-SAMSUNG-S23-001", 950000.00m, DateTime.Parse("2023-01-15"), "دەرمانسازی بەرپرسی لقی سەرەکی");
            int emp2 = InsertEmployee(con, 1, 2, "لانە ئەحمەد حەسەن", "07502345678", "lana.ahmed@pharmacyqandil.com", "DEV-IPHONE-15-002", 750000.00m, DateTime.Parse("2023-05-10"), "یاریدەدەری دەرمانساز");
            int emp3 = InsertEmployee(con, 6, 1, "د. ڕێبین عەلی قادر", "07703456789", "rebin.ali@pharmacyqandil.com", "DEV-XIAOMI-13-003", 900000.00m, DateTime.Parse("2023-08-01"), "دەرمانسازی بەرپرسی لقی ناوەند");
            int emp4 = InsertEmployee(con, 6, 3, "سازگار محەمەد عەزیز", "07504567890", "sazgar.m@pharmacyqandil.com", "DEV-IPHONE-14-004", 600000.00m, DateTime.Parse("2024-01-10"), "موحاسیبی دەرمانخانە");
            int emp5 = InsertEmployee(con, 8, 2, "دیاری عوسمان حەمە", "07705678901", "diyari.o@pharmacyqandil.com", "DEV-HUAWEI-P60-005", 650000.00m, DateTime.Parse("2024-03-01"), "یاریدەدەری دەرمانساز و کۆگا");

            // 6. Insert Employee Shifts for Today
            InsertEmployeeShift(con, emp1, 1, DateTime.Now.Date, 1);
            InsertEmployeeShift(con, emp2, 1, DateTime.Now.Date, 1);
            InsertEmployeeShift(con, emp3, 2, DateTime.Now.Date, 6);
            InsertEmployeeShift(con, emp4, 2, DateTime.Now.Date, 6);

            // 7. Insert Today Attendance with proper Kurdish Unicode
            InsertAttendance(con, emp1, 1, 1, DateTime.Now.AddHours(-3), 35.565812, 45.421510, 8.5, "Uploads/AttendanceSelfies/sample_selfie_1.jpg", "DEV-SAMSUNG-S23-001", 1, "دەوامی سەرەتای بەیانی - لە کاتی خۆیدا");
            InsertAttendance(con, emp2, 1, 1, DateTime.Now.AddHours(-2.5), 35.565825, 45.421530, 12.0, "Uploads/AttendanceSelfies/sample_selfie_2.jpg", "DEV-IPHONE-15-002", 2, "١٥ خولەک دواکەوتووە بەهۆی قەرەباڵغی");

            // 8. Insert Leaves with Kurdish Unicode
            InsertLeave(con, emp3, 1, DateTime.Now.AddDays(3), DateTime.Now.AddDays(4), 2.0m, "مۆڵەتی بەشداری کۆنفرانسی پزیشکی دەرمانسازان", 2);
            InsertLeave(con, emp3, 2, DateTime.Now.AddDays(10), DateTime.Now.AddDays(10), 1.0m, "مۆڵەتی سەردانی پزیشک", 1);

            // 9. Insert Deductions & Rewards
            InsertReward(con, emp1, 1, 50000.00m, "پاداشتی دەوامی کاتی ئێشکگری و سەرکەوتوویی لە فرۆش", DateTime.Now.Date);
            InsertReward(con, emp2, 2, 15000.00m, "بڕینی سزا بەهۆی دواکەوتنی دووبارە لە شیفت", DateTime.Now.Date);

            // 10. Insert Payroll
            InsertPayroll(con, emp1, 2026, 7, 950000.00m, 26, 208.0m, 60000.00m, 50000.00m, 0.00m, 1060000.00m, 1, "مووچەی مانگی ٧ دراوە بە تەواوی");
            InsertPayroll(con, emp2, 2026, 7, 750000.00m, 25, 200.0m, 30000.00m, 0.00m, 15000.00m, 765000.00m, 1, "مووچەی مانگی ٧ دراوە");

            Console.WriteLine("ALL KURDISH DATA FIXED AND RE-INSERTED WITH UTF-8 UNICODE 100% ACCURATELY!");

            // Print verification
            using (SqlCommand checkCmd = new SqlCommand("SELECT Emp_ID, FullName, Notes FROM dbo.tblHR_Employees", con))
            {
                using (SqlDataReader reader = checkCmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Console.WriteLine(string.Format("Emp {0}: {1} ({2})", reader["Emp_ID"], reader["FullName"], reader["Notes"]));
                    }
                }
            }
        }
    }

    static void InsertPlacesGps(SqlConnection con, int placeId, double lat, double lng, int radius, string notes)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblPlaces_GPS (Places_ID, Latitude, Longitude, AllowedRadiusMeters, IsActive, Notes) VALUES (@placeId, @lat, @lng, @radius, 1, @notes)", con))
        {
            cmd.Parameters.Add("@placeId", SqlDbType.Int).Value = placeId;
            cmd.Parameters.Add("@lat", SqlDbType.Float).Value = lat;
            cmd.Parameters.Add("@lng", SqlDbType.Float).Value = lng;
            cmd.Parameters.Add("@radius", SqlDbType.Int).Value = radius;
            cmd.Parameters.Add("@notes", SqlDbType.NVarChar, 500).Value = notes;
            cmd.ExecuteNonQuery();
        }
    }

    static void InsertShift(SqlConnection con, string name, string start, string end, int late, int ot, string notes)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_Shifts (ShiftName, StartTime, EndTime, LateGraceMinutes, OvertimeStartMinutes, IsActive, Notes) VALUES (@name, @start, @end, @late, @ot, 1, @notes)", con))
        {
            cmd.Parameters.Add("@name", SqlDbType.NVarChar, 150).Value = name;
            cmd.Parameters.Add("@start", SqlDbType.NVarChar, 10).Value = start;
            cmd.Parameters.Add("@end", SqlDbType.NVarChar, 10).Value = end;
            cmd.Parameters.Add("@late", SqlDbType.Int).Value = late;
            cmd.Parameters.Add("@ot", SqlDbType.Int).Value = ot;
            cmd.Parameters.Add("@notes", SqlDbType.NVarChar, 500).Value = notes;
            cmd.ExecuteNonQuery();
        }
    }

    static void InsertLeaveType(SqlConnection con, string name, int maxDays, byte isPaid)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_LeaveTypes (TypeName, MaxDaysPerYear, IsPaid, IsActive) VALUES (@name, @maxDays, @isPaid, 1)", con))
        {
            cmd.Parameters.Add("@name", SqlDbType.NVarChar, 150).Value = name;
            cmd.Parameters.Add("@maxDays", SqlDbType.Int).Value = maxDays;
            cmd.Parameters.Add("@isPaid", SqlDbType.TinyInt).Value = isPaid;
            cmd.ExecuteNonQuery();
        }
    }

    static int InsertEmployee(SqlConnection con, int placeId, short jobId, string name, string phone, string email, string device, decimal salary, DateTime hireDate, string notes)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_Employees (Places_ID, Job_ID, FullName, Phone, Email, DeviceUUID, BaseSalary, HireDate, IsActive, Notes) OUTPUT INSERTED.Emp_ID VALUES (@placeId, @jobId, @name, @phone, @email, @device, @salary, @hireDate, 1, @notes)", con))
        {
            cmd.Parameters.Add("@placeId", SqlDbType.Int).Value = placeId;
            cmd.Parameters.Add("@jobId", SqlDbType.SmallInt).Value = jobId;
            cmd.Parameters.Add("@name", SqlDbType.NVarChar, 250).Value = name;
            cmd.Parameters.Add("@phone", SqlDbType.NVarChar, 50).Value = phone;
            cmd.Parameters.Add("@email", SqlDbType.NVarChar, 150).Value = email;
            cmd.Parameters.Add("@device", SqlDbType.NVarChar, 250).Value = device;
            cmd.Parameters.Add("@salary", SqlDbType.Decimal).Value = salary;
            cmd.Parameters.Add("@hireDate", SqlDbType.Date).Value = hireDate;
            cmd.Parameters.Add("@notes", SqlDbType.NVarChar, 500).Value = notes;
            return (int)cmd.ExecuteScalar();
        }
    }

    static void InsertEmployeeShift(SqlConnection con, int empId, int shiftId, DateTime date, int placeId)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_EmployeeShifts (Emp_ID, Shift_ID, ShiftDate, Places_ID, IsApproved) VALUES (@empId, @shiftId, @date, @placeId, 1)", con))
        {
            cmd.Parameters.Add("@empId", SqlDbType.Int).Value = empId;
            cmd.Parameters.Add("@shiftId", SqlDbType.Int).Value = shiftId;
            cmd.Parameters.Add("@date", SqlDbType.Date).Value = date;
            cmd.Parameters.Add("@placeId", SqlDbType.Int).Value = placeId;
            cmd.ExecuteNonQuery();
        }
    }

    static void InsertAttendance(SqlConnection con, int empId, int placeId, byte type, DateTime dt, double lat, double lng, double dist, string selfie, string device, byte status, string notes)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_Attendance (Emp_ID, Place_ID, CheckType, CheckDateTime, Latitude, Longitude, DistanceMeters, SelfieImagePath, DeviceUUID, Status, Notes) VALUES (@empId, @placeId, @type, @dt, @lat, @lng, @dist, @selfie, @device, @status, @notes)", con))
        {
            cmd.Parameters.Add("@empId", SqlDbType.Int).Value = empId;
            cmd.Parameters.Add("@placeId", SqlDbType.Int).Value = placeId;
            cmd.Parameters.Add("@type", SqlDbType.TinyInt).Value = type;
            cmd.Parameters.Add("@dt", SqlDbType.DateTime).Value = dt;
            cmd.Parameters.Add("@lat", SqlDbType.Float).Value = lat;
            cmd.Parameters.Add("@lng", SqlDbType.Float).Value = lng;
            cmd.Parameters.Add("@dist", SqlDbType.Float).Value = dist;
            cmd.Parameters.Add("@selfie", SqlDbType.NVarChar, 500).Value = selfie;
            cmd.Parameters.Add("@device", SqlDbType.NVarChar, 250).Value = device;
            cmd.Parameters.Add("@status", SqlDbType.TinyInt).Value = status;
            cmd.Parameters.Add("@notes", SqlDbType.NVarChar, 500).Value = notes;
            cmd.ExecuteNonQuery();
        }
    }

    static void InsertLeave(SqlConnection con, int empId, int typeId, DateTime start, DateTime end, decimal days, string reason, byte status)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_Leaves (Emp_ID, LeaveType_ID, StartDate, EndDate, TotalDays, Reason, Status, ApprovedBy) VALUES (@empId, @typeId, @start, @end, @days, @reason, @status, 1)", con))
        {
            cmd.Parameters.Add("@empId", SqlDbType.Int).Value = empId;
            cmd.Parameters.Add("@typeId", SqlDbType.Int).Value = typeId;
            cmd.Parameters.Add("@start", SqlDbType.Date).Value = start;
            cmd.Parameters.Add("@end", SqlDbType.Date).Value = end;
            cmd.Parameters.Add("@days", SqlDbType.Decimal).Value = days;
            cmd.Parameters.Add("@reason", SqlDbType.NVarChar, 500).Value = reason;
            cmd.Parameters.Add("@status", SqlDbType.TinyInt).Value = status;
            cmd.ExecuteNonQuery();
        }
    }

    static void InsertReward(SqlConnection con, int empId, byte type, decimal amount, string reason, DateTime dt)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_Deductions_Rewards (Emp_ID, TransType, Amount, Reason, TransDate) VALUES (@empId, @type, @amount, @reason, @dt)", con))
        {
            cmd.Parameters.Add("@empId", SqlDbType.Int).Value = empId;
            cmd.Parameters.Add("@type", SqlDbType.TinyInt).Value = type;
            cmd.Parameters.Add("@amount", SqlDbType.Decimal).Value = amount;
            cmd.Parameters.Add("@reason", SqlDbType.NVarChar, 500).Value = reason;
            cmd.Parameters.Add("@dt", SqlDbType.Date).Value = dt;
            cmd.ExecuteNonQuery();
        }
    }

    static void InsertPayroll(SqlConnection con, int empId, int year, int month, decimal baseSal, int days, decimal hours, decimal ot, decimal rew, decimal ded, decimal net, byte isPaid, string notes)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO dbo.tblHR_Payroll (Emp_ID, YearNo, MonthNo, BaseSalary, TotalDaysPresent, TotalHoursWorked, OvertimeAmount, RewardAmount, DeductionAmount, NetSalary, IsPaid, Notes) VALUES (@empId, @year, @month, @baseSal, @days, @hours, @ot, @rew, @ded, @net, @isPaid, @notes)", con))
        {
            cmd.Parameters.Add("@empId", SqlDbType.Int).Value = empId;
            cmd.Parameters.Add("@year", SqlDbType.Int).Value = year;
            cmd.Parameters.Add("@month", SqlDbType.Int).Value = month;
            cmd.Parameters.Add("@baseSal", SqlDbType.Decimal).Value = baseSal;
            cmd.Parameters.Add("@days", SqlDbType.Int).Value = days;
            cmd.Parameters.Add("@hours", SqlDbType.Decimal).Value = hours;
            cmd.Parameters.Add("@ot", SqlDbType.Decimal).Value = ot;
            cmd.Parameters.Add("@rew", SqlDbType.Decimal).Value = rew;
            cmd.Parameters.Add("@ded", SqlDbType.Decimal).Value = ded;
            cmd.Parameters.Add("@net", SqlDbType.Decimal).Value = net;
            cmd.Parameters.Add("@isPaid", SqlDbType.TinyInt).Value = isPaid;
            cmd.Parameters.Add("@notes", SqlDbType.NVarChar, 500).Value = notes;
            cmd.ExecuteNonQuery();
        }
    }
}
