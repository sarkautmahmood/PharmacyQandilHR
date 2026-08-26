using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Leave_ManagementPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadLeaves();
        }
    }

    private void LoadLeaves()
    {
        try
        {
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "HR_Leaves_SelectAll", null, true);
            gvLeaves.DataSource = dt;
            gvLeaves.DataBind();
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە لە بارکردنی مۆڵەتەکان: " + ex.Message);
        }
    }

    protected void gvLeaves_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int leaveId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "ApproveLeave" || e.CommandName == "RejectLeave")
        {
            byte newStatus = e.CommandName == "ApproveLeave" ? (byte)2 : (byte)3;

            try
            {
                // Fetch existing leave details
                var getParams = new Dictionary<string, object> { { "@Leave_ID", leaveId } };
                DataTable dt = _db.GetDataTable("PharmacyQandilDB", "HR_Leaves_selectID", getParams, true);

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    var updateParams = new Dictionary<string, object>
                    {
                        { "@Leave_ID", leaveId },
                        { "@user_update", 1 },
                        { "@Emp_ID", Convert.ToInt32(r["Emp_ID"]) },
                        { "@LeaveType_ID", Convert.ToInt32(r["LeaveType_ID"]) },
                        { "@StartDate", Convert.ToDateTime(r["StartDate"]).Date },
                        { "@EndDate", Convert.ToDateTime(r["EndDate"]).Date },
                        { "@TotalDays", Convert.ToDecimal(r["TotalDays"]) },
                        { "@Reason", r["Reason"].ToString() },
                        { "@Status", newStatus },
                        { "@ApprovedBy", 1 }
                    };

                    string res = _db.ExecuteSP("PharmacyQandilDB", "HR_Leaves_Update", updateParams);
                    if (res == "1")
                    {
                        ShowAlert("success", newStatus == 2 ? "داواکاری مۆڵەت بە سەرکەوتوویی پەسەندکرا." : "داواکاری مۆڵەت ڕەتکرایەوە.");
                        LoadLeaves();
                    }
                    else
                    {
                        ShowAlert("danger", "هەڵە لە تۆمارکردنی بڕیار لە داتابەیس.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("danger", "کێشە: " + ex.Message);
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
