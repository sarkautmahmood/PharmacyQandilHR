using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;

public partial class Payroll_ProcessorPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPayroll();
        }
    }

    private void LoadPayroll()
    {
        try
        {
            int year = Convert.ToInt32(ddlYear.SelectedValue);
            int month = Convert.ToInt32(ddlMonth.SelectedValue);

            var parameters = new Dictionary<string, object>
            {
                { "@YearNo", year },
                { "@MonthNo", month }
            };

            string sql = @"
                SELECT p.*, e.FullName, pl.Places_Name 
                FROM dbo.tblHR_Payroll p
                INNER JOIN dbo.tblHR_Employees e ON p.Emp_ID = e.Emp_ID
                LEFT JOIN dbo.tblPlaces pl ON e.Places_ID = pl.Places_ID
                WHERE p.YearNo = @YearNo AND p.MonthNo = @MonthNo
                ORDER BY p.Payroll_ID DESC;";

            DataTable dt = _db.GetDataTable("PharmacyQandilDB", sql, parameters, false);
            gvPayroll.DataSource = dt;
            gvPayroll.DataBind();
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە: " + ex.Message);
        }
    }

    protected void btnLoadPayroll_Click(object sender, EventArgs e)
    {
        LoadPayroll();
    }

    private void ShowAlert(string type, string msg)
    {
        pnlAlert.Visible = true;
        pnlAlert.CssClass = "alert alert-" + type + " alert-dismissible fade show";
        lblAlertMsg.Text = msg;
    }
}
