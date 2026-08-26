using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Employee_ManagerPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdowns();
            LoadEmployees();
        }
    }

    private void LoadDropdowns()
    {
        try
        {
            // Places
            string sqlPlaces = "SELECT Places_ID, Places_Name FROM dbo.tblPlaces WHERE PVisible = 1 ORDER BY Places_ID;";
            DataTable dtPlaces = _db.GetDataTable("PharmacyQandilDB", sqlPlaces, null, false);
            ddlPlace.DataSource = dtPlaces;
            ddlPlace.DataTextField = "Places_Name";
            ddlPlace.DataValueField = "Places_ID";
            ddlPlace.DataBind();
            ddlPlace.Items.Insert(0, new ListItem("هەڵبژێرە...", "0"));

            // Job Titles
            string sqlJobs = "SELECT Job_ID, JobTitle FROM dbo.tblUserJobTitle ORDER BY Job_ID;";
            DataTable dtJobs = _db.GetDataTable("PharmacyQandilDB", sqlJobs, null, false);
            ddlJob.DataSource = dtJobs;
            ddlJob.DataTextField = "JobTitle";
            ddlJob.DataValueField = "Job_ID";
            ddlJob.DataBind();
            ddlJob.Items.Insert(0, new ListItem("دیاری نەکراوە", "0"));
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە لە بارکردنی زانیارییەکان: " + ex.Message);
        }
    }

    private void LoadEmployees()
    {
        try
        {
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "HR_Employees_SelectAll", null, true);
            gvEmployees.DataSource = dt;
            gvEmployees.DataBind();
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە لە بارکردنی کارمەندان: " + ex.Message);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(txtFullName.Text) || ddlPlace.SelectedValue == "0")
            {
                ShowAlert("warning", "تکایە ناوی تەواو و لقی دەرمانخانە دیاری بکە.");
                return;
            }

            int empID = Convert.ToInt32(hfEmpID.Value);
            decimal baseSalary = 0;
            decimal.TryParse(txtBaseSalary.Text, out baseSalary);

            var parameters = new Dictionary<string, object>
            {
                { "@Places_ID", Convert.ToInt32(ddlPlace.SelectedValue) },
                { "@Job_ID", ddlJob.SelectedValue != "0" ? (object)Convert.ToInt16(ddlJob.SelectedValue) : DBNull.Value },
                { "@FullName", txtFullName.Text.Trim() },
                { "@Phone", txtPhone.Text.Trim() },
                { "@Email", txtEmail.Text.Trim() },
                { "@NationalID", DBNull.Value },
                { "@DeviceUUID", !string.IsNullOrEmpty(txtDeviceUUID.Text) ? txtDeviceUUID.Text.Trim() : (object)DBNull.Value },
                { "@BaseSalary", baseSalary },
                { "@HireDate", !string.IsNullOrEmpty(txtHireDate.Text) ? (object)DateTime.Parse(txtHireDate.Text).Date : DBNull.Value },
                { "@IsActive", 1 },
                { "@Notes", txtNotes.Text.Trim() }
            };

            string result = "";
            if (empID == 0) // Insert
            {
                parameters.Add("@user_insert", 1);
                parameters.Add("@UserId", DBNull.Value);
                result = _db.ExecuteSP("PharmacyQandilDB", "HR_Employees_Insert", parameters);
            }
            else // Update
            {
                parameters.Add("@Emp_ID", empID);
                parameters.Add("@user_update", 1);
                parameters.Add("@UserId", DBNull.Value);
                result = _db.ExecuteSP("PharmacyQandilDB", "HR_Employees_Update", parameters);
            }

            if (result == "1")
            {
                ShowAlert("success", empID == 0 ? "کارمەند بە سەرکەوتوویی تۆمارکرا." : "زانیارییەکانی کارمەند نوێکرانەوە.");
                ClearForm();
                LoadEmployees();
            }
            else
            {
                ShowAlert("danger", "هەڵە لە پاشەکەوتکردنی داتا لە داتابەیس.");
            }
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "کێشە: " + ex.Message);
        }
    }

    protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int empId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditEmp")
        {
            var parameters = new Dictionary<string, object> { { "@Emp_ID", empId } };
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "HR_Employees_selectID", parameters, true);

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                hfEmpID.Value = empId.ToString();
                txtFullName.Text = r["FullName"].ToString();
                ddlPlace.SelectedValue = r["Places_ID"].ToString();
                if (r["Job_ID"] != DBNull.Value) ddlJob.SelectedValue = r["Job_ID"].ToString();
                txtPhone.Text = r["Phone"].ToString();
                txtEmail.Text = r["Email"].ToString();
                txtBaseSalary.Text = r["BaseSalary"].ToString();
                if (r["HireDate"] != DBNull.Value) txtHireDate.Text = Convert.ToDateTime(r["HireDate"]).ToString("yyyy-MM-dd");
                txtDeviceUUID.Text = r["DeviceUUID"].ToString();
                txtNotes.Text = r["Notes"].ToString();

                litFormTitle.Text = "دەستکاریکردنی کارمەند: " + r["FullName"].ToString();
                btnSave.Text = "نوێکردنەوەی زانیارییەکان";
            }
        }
        else if (e.CommandName == "DeleteEmp")
        {
            var parameters = new Dictionary<string, object>
            {
                { "@Emp_ID", empId },
                { "@user_delete", 1 },
                { "@Places_Fkey", DBNull.Value }
            };

            string res = _db.ExecuteSP("PharmacyQandilDB", "HR_Employees_delete", parameters);
            if (res == "1")
            {
                ShowAlert("success", "کارمەند بە سەرکەوتوویی سڕایەوە.");
                LoadEmployees();
            }
            else
            {
                ShowAlert("danger", "نەتوانرا بسڕدرێتەوە لەبەر پەیوەستبوونی بە تۆمارەکانی تر.");
            }
        }
    }

    private void ClearForm()
    {
        hfEmpID.Value = "0";
        txtFullName.Text = "";
        ddlPlace.SelectedIndex = 0;
        ddlJob.SelectedIndex = 0;
        txtPhone.Text = "";
        txtEmail.Text = "";
        txtBaseSalary.Text = "";
        txtHireDate.Text = "";
        txtDeviceUUID.Text = "";
        txtNotes.Text = "";
        litFormTitle.Text = "تۆمارکردنی کارمەندی نوێ";
        btnSave.Text = "پاشەکەوتکردنی زانیارییەکان";
    }

    private void ShowAlert(string type, string msg)
    {
        pnlAlert.Visible = true;
        pnlAlert.CssClass = "alert alert-" + type + " alert-dismissible fade show";
        lblAlertMsg.Text = msg;
    }
}
