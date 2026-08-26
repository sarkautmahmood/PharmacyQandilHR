using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Places_GPS_SettingsPage : Page
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPlacesDropdown();
            LoadGpsRecords();
        }
    }

    private void LoadPlacesDropdown()
    {
        try
        {
            string sql = "SELECT Places_ID, Places_Name FROM dbo.tblPlaces WHERE PVisible = 1 ORDER BY Places_ID;";
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", sql, null, false);
            ddlPlaces.DataSource = dt;
            ddlPlaces.DataTextField = "Places_Name";
            ddlPlaces.DataValueField = "Places_ID";
            ddlPlaces.DataBind();
            ddlPlaces.Items.Insert(0, new ListItem("هەڵبژێرە...", "0"));
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە: " + ex.Message);
        }
    }

    private void LoadGpsRecords()
    {
        try
        {
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "Places_GPS_SelectAll", null, true);
            gvPlacesGps.DataSource = dt;
            gvPlacesGps.DataBind();
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "هەڵە: " + ex.Message);
        }
    }

    protected void btnSaveGps_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlPlaces.SelectedValue == "0" || string.IsNullOrEmpty(txtLatitude.Text) || string.IsNullOrEmpty(txtLongitude.Text))
            {
                ShowAlert("warning", "تکایە هەموو خانە پێویستەکان پڕبکەرەوە.");
                return;
            }

            int gpsId = Convert.ToInt32(hfPlacesGpsID.Value);
            double lat = Convert.ToDouble(txtLatitude.Text.Trim());
            double lng = Convert.ToDouble(txtLongitude.Text.Trim());
            int radius = !string.IsNullOrEmpty(txtRadius.Text) ? Convert.ToInt32(txtRadius.Text) : 50;

            var parameters = new Dictionary<string, object>
            {
                { "@Places_ID", Convert.ToInt32(ddlPlaces.SelectedValue) },
                { "@Latitude", lat },
                { "@Longitude", lng },
                { "@AllowedRadiusMeters", radius },
                { "@IsActive", 1 },
                { "@Notes", txtNotes.Text.Trim() }
            };

            string res = "";
            if (gpsId == 0) // Insert
            {
                parameters.Add("@user_insert", 1);
                res = _db.ExecuteSP("PharmacyQandilDB", "Places_GPS_Insert", parameters);
            }
            else // Update
            {
                parameters.Add("@Places_GPS_ID", gpsId);
                parameters.Add("@user_update", 1);
                res = _db.ExecuteSP("PharmacyQandilDB", "Places_GPS_Update", parameters);
            }

            if (res == "1")
            {
                ShowAlert("success", "شوێنی دەرمانخانە بە سەرکەوتوویی پاشەکەوتکرا.");
                ClearForm();
                LoadGpsRecords();
            }
            else
            {
                ShowAlert("danger", "هەڵە لە پاشەکەوتکردن لە داتابەیس.");
            }
        }
        catch (Exception ex)
        {
            ShowAlert("danger", "کێشە: " + ex.Message);
        }
    }

    protected void gvPlacesGps_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditGps")
        {
            int gpsId = Convert.ToInt32(e.CommandArgument);
            var parameters = new Dictionary<string, object> { { "@Places_GPS_ID", gpsId } };
            DataTable dt = _db.GetDataTable("PharmacyQandilDB", "Places_GPS_selectID", parameters, true);

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                hfPlacesGpsID.Value = gpsId.ToString();
                ddlPlaces.SelectedValue = r["Places_ID"].ToString();
                txtLatitude.Text = r["Latitude"].ToString();
                txtLongitude.Text = r["Longitude"].ToString();
                txtRadius.Text = r["AllowedRadiusMeters"].ToString();
                txtNotes.Text = r["Notes"].ToString();

                litFormTitle.Text = "دەستکاریکردنی شوێنی لق: " + r["Places_Name"].ToString();
                btnSaveGps.Text = "نوێکردنەوەی شوێن";
            }
        }
    }

    private void ClearForm()
    {
        hfPlacesGpsID.Value = "0";
        ddlPlaces.SelectedIndex = 0;
        txtLatitude.Text = "";
        txtLongitude.Text = "";
        txtRadius.Text = "50";
        txtNotes.Text = "";
        litFormTitle.Text = "دیاریکردنی لۆکەیشنی دەرمانخانە";
        btnSaveGps.Text = "پاشەکەوتکردنی شوێنی دەرمانخانە";
    }

    private void ShowAlert(string type, string msg)
    {
        pnlAlert.Visible = true;
        pnlAlert.CssClass = "alert alert-" + type + " alert-dismissible fade show";
        lblAlertMsg.Text = msg;
    }
}
