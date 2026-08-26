using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;

/// <summary>
/// SOAP Web Service for Employee Portal: Profile, Shifts, Leave Requests, and Monthly Payroll Slips
/// </summary>
[WebService(Namespace = "http://pharmacyqandil.com/hr/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class HR_PortalService : System.Web.Services.WebService
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    public class PortalResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string Data { get; set; }
    }

    [WebMethod(Description = "Get employee profile information")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public DataTable Get_Employee_Profile(int empID)
    {
        var parameters = new Dictionary<string, object> { { "@Emp_ID", empID } };
        return _db.GetDataTable("PharmacyQandilDB", "HR_Employees_selectID", parameters, true);
    }

    [WebMethod(Description = "Get upcoming shifts for an employee")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public DataTable Get_Employee_Shifts(int empID)
    {
        var parameters = new Dictionary<string, object>
        {
            { "@Emp_ID", empID },
            { "@StartDate", DateTime.Now.Date.AddDays(-1) }
        };

        string sql = @"
            SELECT es.EmpShift_ID, es.ShiftDate, s.ShiftName, s.StartTime, s.EndTime, p.Places_Name, es.IsApproved
            FROM dbo.tblHR_EmployeeShifts es
            INNER JOIN dbo.tblHR_Shifts s ON es.Shift_ID = s.Shift_ID
            INNER JOIN dbo.tblPlaces p ON es.Places_ID = p.Places_ID
            WHERE es.Emp_ID = @Emp_ID AND es.ShiftDate >= @StartDate
            ORDER BY es.ShiftDate ASC;";

        return _db.GetDataTable("PharmacyQandilDB", sql, parameters, false);
    }

    [WebMethod(Description = "Submit a leave request from mobile app")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PortalResponse Request_Leave(int empID, int leaveTypeID, string startDate, string endDate, string reason)
    {
        PortalResponse response = new PortalResponse();

        try
        {
            DateTime start = DateTime.Parse(startDate);
            DateTime end = DateTime.Parse(endDate);
            decimal totalDays = (decimal)(end.Date - start.Date).TotalDays + 1;

            if (totalDays <= 0)
            {
                response.Success = false;
                response.Message = "بەرواری کۆتایی دەبێت لە دوای بەرواری دەستپێک بێت.";
                return response;
            }

            var parameters = new Dictionary<string, object>
            {
                { "@user_insert", 1 },
                { "@Emp_ID", empID },
                { "@LeaveType_ID", leaveTypeID },
                { "@StartDate", start.Date },
                { "@EndDate", end.Date },
                { "@TotalDays", totalDays },
                { "@Reason", reason },
                { "@Status", 1 }, // 1: Pending
                { "@ApprovedBy", DBNull.Value }
            };

            string spResult = _db.ExecuteSP("PharmacyQandilDB", "HR_Leaves_Insert", parameters);
            if (spResult == "1")
            {
                response.Success = true;
                response.Message = "داواکاری مۆڵەت بە سەرکەوتوویی نێردرا و چاوەڕوانی پەسەندکردنی بەڕێوەبەرە.";
            }
            else
            {
                response.Success = false;
                response.Message = "هەڵە لە ناردنی داواکاری مۆڵەت لە داتابەیس.";
            }
        }
        catch (Exception ex)
        {
            response.Success = false;
            response.Message = "کێشە: " + ex.Message;
        }

        return response;
    }

    [WebMethod(Description = "Get employee leave history and requests")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public DataTable Get_Leave_History(int empID)
    {
        var parameters = new Dictionary<string, object> { { "@Emp_ID", empID } };
        string sql = @"
            SELECT l.Leave_ID, lt.TypeName, l.StartDate, l.EndDate, l.TotalDays, l.Reason, l.Status,
                   CASE WHEN l.Status = 1 THEN N'چاوەڕوان (Pending)' 
                        WHEN l.Status = 2 THEN N'پەسەندکراو (Approved)' 
                        ELSE N'ڕەتکراوە (Rejected)' END AS StatusName
            FROM dbo.tblHR_Leaves l
            INNER JOIN dbo.tblHR_LeaveTypes lt ON l.LeaveType_ID = lt.LeaveType_ID
            WHERE l.Emp_ID = @Emp_ID
            ORDER BY l.StartDate DESC;";

        return _db.GetDataTable("PharmacyQandilDB", sql, parameters, false);
    }

    [WebMethod(Description = "Get monthly payroll summary for employee")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public DataTable Get_Payroll_Summary(int empID, int year, int month)
    {
        var parameters = new Dictionary<string, object>
        {
            { "@Emp_ID", empID },
            { "@YearNo", year },
            { "@MonthNo", month }
        };

        string sql = @"
            SELECT * FROM dbo.tblHR_Payroll 
            WHERE Emp_ID = @Emp_ID AND YearNo = @YearNo AND MonthNo = @MonthNo;";

        return _db.GetDataTable("PharmacyQandilDB", sql, parameters, false);
    }
}
