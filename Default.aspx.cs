using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;

public partial class DefaultPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDashboardData();
        }
    }

    private void LoadDashboardData()
    {
        try
        {
            // 1. Dashboard Stats
            DataTable dtStats = _db.GetDataTable("PharmacyQandilDB", "HR_Dashboard_Stats", null, true);
            if (dtStats.Rows.Count > 0)
            {
                lblTotalEmployees.Text = dtStats.Rows[0]["TotalEmployees"].ToString();
                lblTodayAttendance.Text = dtStats.Rows[0]["TodayAttendance"].ToString();
                lblPendingLeaves.Text = dtStats.Rows[0]["PendingLeaves"].ToString();
                lblTotalBranches.Text = dtStats.Rows[0]["TotalBranches"].ToString();
            }

            // 2. Today Attendance
            string sqlAttendance = @"
                SELECT a.*, e.FullName, p.Places_Name 
                FROM dbo.tblHR_Attendance a
                LEFT JOIN dbo.tblHR_Employees e ON a.Emp_ID = e.Emp_ID
                LEFT JOIN dbo.tblPlaces p ON a.Place_ID = p.Places_ID
                WHERE CONVERT(date, a.CheckDateTime) = CONVERT(date, GETDATE())
                ORDER BY a.CheckDateTime DESC;";

            DataTable dtAttendance = _db.GetDataTable("PharmacyQandilDB", sqlAttendance, null, false);
            gvTodayAttendance.DataSource = dtAttendance;
            gvTodayAttendance.DataBind();

            // 3. Today Shifts
            string sqlShifts = @"
                SELECT es.*, e.FullName, s.ShiftName, s.StartTime, s.EndTime, p.Places_Name
                FROM dbo.tblHR_EmployeeShifts es
                LEFT JOIN dbo.tblHR_Employees e ON es.Emp_ID = e.Emp_ID
                LEFT JOIN dbo.tblHR_Shifts s ON es.Shift_ID = s.Shift_ID
                LEFT JOIN dbo.tblPlaces p ON es.Places_ID = p.Places_ID
                WHERE es.ShiftDate = CONVERT(date, GETDATE())
                ORDER BY es.EmpShift_ID ASC;";

            DataTable dtShifts = _db.GetDataTable("PharmacyQandilDB", sqlShifts, null, false);
            rptTodayShifts.DataSource = dtShifts;
            rptTodayShifts.DataBind();
        }
        catch (Exception ex)
        {
            // Error handling
            Response.Write("<script>console.error('Error loading dashboard: " + ex.Message + "');</script>");
        }
    }
}
