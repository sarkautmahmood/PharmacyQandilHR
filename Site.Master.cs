using System;
using System.IO;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public string GetActiveClass(string pageName)
    {
        string currentPage = Path.GetFileName(Request.Path);
        return string.Equals(currentPage, pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
    }
}
