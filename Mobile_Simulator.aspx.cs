using System;
using System.Data;
using System.Web.UI;

public partial class Mobile_SimulatorPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdowns();
        }
    }

    private void LoadDropdowns()
    {
        try
        {
            // Employees
            DataTable dtEmp = _db.GetDataTable("PharmacyQandilDB", "HR_Employees_SelectAll", null, true);
            ddlTestEmp.DataSource = dtEmp;
            ddlTestEmp.DataTextField = "FullName";
            ddlTestEmp.DataValueField = "Emp_ID";
            ddlTestEmp.DataBind();

            // Places
            string sqlPlaces = "SELECT Places_ID, Places_Name FROM dbo.tblPlaces WHERE PVisible = 1 ORDER BY Places_ID;";
            DataTable dtPlaces = _db.GetDataTable("PharmacyQandilDB", sqlPlaces, null, false);
            ddlTestPlace.DataSource = dtPlaces;
            ddlTestPlace.DataTextField = "Places_Name";
            ddlTestPlace.DataValueField = "Places_ID";
            ddlTestPlace.DataBind();
        }
        catch (Exception ex)
        {
            Response.Write("<script>console.error('" + ex.Message + "');</script>");
        }
    }
}
