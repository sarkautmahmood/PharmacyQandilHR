using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Shift_SchedulerPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtShiftDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            LoadDropdowns();
            LoadShiftTypes();
            LoadEmployeeShifts();
        }
    }

    private void LoadDropdowns()
    {
        try
        {
            // Employees
            DataTable dtEmp = _db.GetDataTable("PharmacyQandilDB", "HR_Employees_SelectAll", null, true);
            ddlEmp.DataSource = dtEmp;
            ddlEmp.DataTextField = "FullName";
            ddlEmp.DataValueField = "Emp_ID";
            ddlEmp.DataBind();
            ddlEmp.Items.Insert(0, new ListItem("هەڵبژێرە...", "0"));

            // Shifts
            DataTable dtShifts = _db.GetDataTable("PharmacyQandilDB", "HR_Shifts_SelectAll", null, true);
            ddlShift.DataSource = dtShifts;
            ddlShift.DataTextField = "ShiftName";
            ddlShift.DataValueField = "Shift_ID";
            ddlShift.DataBind();
            ddlShift.Items.Insert(0, new ListItem("هەڵبژێرە...", "0"));

            // Places
            string sqlPlaces = "SELECT Places_ID, Places_Name FROM dbo.tblPlaces WHERE PVisible = 1 ORDER BY Places_ID;";
            DataTable dtPlaces = _db.GetDataTable("PharmacyQandilDB", sqlPlaces, null, false);
            ddlShiftPlace.DataSource = dtPlaces;
            ddlShiftPlace.DataTextField = "Places_Name";
            ddlShiftPlace.DataValueField = "Places_ID";
            ddlShiftPlace.DataBind();
            ddlShiftPlace.Items.Insert(0, new ListItem("هەڵبژێرە...", "0"));
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە: " + ex.Message);
        }
    }

    private void LoadShiftTypes()
    {
        try
        {
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "HR_Shifts_SelectAll", null, true);
            rptShiftTypes.DataSource = dt;
            rptShiftTypes.DataBind();
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە: " + ex.Message);
        }
    }

    private void LoadEmployeeShifts()
    {
        try
        {
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "HR_EmployeeShifts_SelectAll", null, true);
            gvEmployeeShifts.DataSource = dt;
            gvEmployeeShifts.DataBind();
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە: " + ex.Message);
        }
    }

    protected void btnAssignShift_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlEmp.SelectedValue == "0" || ddlShift.SelectedValue == "0" || ddlShiftPlace.SelectedValue == "0" || string.IsNullOrEmpty(txtShiftDate.Text))
            {
                ShowAlert("warning", "تکایە هەموو خانە پێویستەکان پڕبکەرەوە.");
                return;
            }

            var parameters = new Dictionary<string, object>
            {
                { "@user_insert", 1 },
                { "@Emp_ID", Convert.ToInt32(ddlEmp.SelectedValue) },
                { "@Shift_ID", Convert.ToInt32(ddlShift.SelectedValue) },
                { "@ShiftDate", DateTime.Parse(txtShiftDate.Text).Date },
                { "@Places_ID", Convert.ToInt32(ddlShiftPlace.SelectedValue) },
                { "@IsApproved", 1 },
                { "@Notes", "شیفتی دیاریکراوی دەرمانخانە" }
            };

            string res = _db.ExecuteSP("PharmacyQandilDB", "HR_EmployeeShifts_Insert", parameters);
            if (res == "1")
            {
                ShowAlert("success", "شیفت بە سەرکەوتوویی بۆ کارمەند دیاری کرا.");
                LoadEmployeeShifts();
            }
            else
            {
                ShowAlert("danger", "هەڵە لە پاشەکەوتکردنی شیفت.");
            }
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "کێشە: " + ex.Message);
        }
    }

    protected void gvEmployeeShifts_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteShift")
        {
            int shiftId = Convert.ToInt32(e.CommandArgument);
            var parameters = new Dictionary<string, object>
            {
                { "@EmpShift_ID", shiftId },
                { "@user_delete", 1 },
                { "@Places_Fkey", DBNull.Value }
            };

            string res = _db.ExecuteSP("PharmacyQandilDB", "HR_EmployeeShifts_delete", parameters);
            if (res == "1")
            {
                ShowAlert("success", "شیفت بە سەرکەوتوویی لادرا.");
                LoadEmployeeShifts();
            }
            else
            {
                ShowAlert("danger", "هەڵە لە لابردنی شیفت.");
            }
        }
    }

    private void ShowAlert(string type, string msg)
    {
        pnlAlert.Visible = true;
        pnlAlert.CssClass = "alert alert-" + type + " alert-dismissible fade show";
        lblAlertMsg.Text = msg;
    }
}
