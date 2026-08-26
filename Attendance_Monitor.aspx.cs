using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Attendance_MonitorPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFilterDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            LoadBranches();
            LoadAttendanceRecords();
        }
    }

    private void LoadBranches()
    {
        try
        {
            string sql = "SELECT Places_ID, Places_Name FROM dbo.tblPlaces WHERE PVisible = 1 ORDER BY Places_ID;";
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", sql, null, false);
            ddlFilterPlace.DataSource = dt;
            ddlFilterPlace.DataTextField = "Places_Name";
            ddlFilterPlace.DataValueField = "Places_ID";
            ddlFilterPlace.DataBind();
            ddlFilterPlace.Items.Insert(0, new ListItem("هەموو لقەکان", "0"));
        }
        catch (Exception ex)
        {
            Response.Write("<script>console.error('" + ex.Message + "');</script>");
        }
    }

    private void LoadAttendanceRecords()
    {
        try
        {
            var parameters = new Dictionary<string, object>();
            string sql = @"
                SELECT a.*, e.FullName, p.Places_Name 
                FROM dbo.tblHR_Attendance a
                LEFT JOIN dbo.tblHR_Employees e ON a.Emp_ID = e.Emp_ID
                LEFT JOIN dbo.tblPlaces p ON a.Place_ID = p.Places_ID
                WHERE 1=1";

            if (!string.IsNullOrEmpty(txtFilterDate.Text))
            {
                sql += " AND CONVERT(date, a.CheckDateTime) = @FilterDate";
                parameters.Add("@FilterDate", DateTime.Parse(txtFilterDate.Text).Date);
            }

            if (ddlFilterPlace.SelectedValue != "0" && !string.IsNullOrEmpty(ddlFilterPlace.SelectedValue))
            {
                sql += " AND a.Place_ID = @Place_ID";
                parameters.Add("@Place_ID", Convert.ToInt32(ddlFilterPlace.SelectedValue));
            }

            if (ddlFilterStatus.SelectedValue != "0")
            {
                sql += " AND a.Status = @Status";
                parameters.Add("@Status", Convert.ToByte(ddlFilterStatus.SelectedValue));
            }

            sql += " ORDER BY a.CheckDateTime DESC;";

            DataTable dt = _db.GetDataTable("PharmacyQandilDB", sql, parameters, false);
            gvAttendance.DataSource = dt;
            gvAttendance.DataBind();
            lblRecordCount.Text = dt.Rows.Count.ToString();
        }
        catch (Exception ex)
        {
            Response.Write("<script>console.error('" + ex.Message + "');</script>");
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadAttendanceRecords();
    }
}
