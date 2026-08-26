using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

/// <summary>
/// Central Helper class for dynamic database operations (PharmacyQandilDB Standard)
/// </summary>
public class Fun_DataHelper
{
    private static readonly string DefaultConnName = "PharmacyQandilDB";

    public Fun_DataHelper()
    {
    }

    public string ExecuteSP(string connectionStringName, string storedProcedureName, Dictionary<string, object> parameters, string outParameterName = "@ErrorMessage", int outParameterSize = 50)
    {
        string connName = string.IsNullOrEmpty(connectionStringName) ? DefaultConnName : connectionStringName;
        string connectionString = ConfigurationManager.ConnectionStrings[connName].ConnectionString;
        string result = "";

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(storedProcedureName, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 120;

                if (parameters != null)
                {
                    foreach (KeyValuePair<string, object> param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
                    }
                }

                if (!string.IsNullOrEmpty(outParameterName))
                {
                    SqlParameter outParam = new SqlParameter(outParameterName, SqlDbType.VarChar, outParameterSize);
                    outParam.Direction = ParameterDirection.InputOutput;
                    outParam.Value = "00000";
                    cmd.Parameters.Add(outParam);
                }

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();

                    if (!string.IsNullOrEmpty(outParameterName))
                    {
                        if (cmd.Parameters[outParameterName].Value != DBNull.Value)
                        {
                            result = cmd.Parameters[outParameterName].Value.ToString();
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        return result;
    }

    public string ExecuteSPWithoutOutput(string connectionStringName, string storedProcedureName, Dictionary<string, object> parameters)
    {
        string result = "";
        string connName = string.IsNullOrEmpty(connectionStringName) ? DefaultConnName : connectionStringName;
        string connectionString = ConfigurationManager.ConnectionStrings[connName].ConnectionString;

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(storedProcedureName, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 120;

                if (parameters != null)
                {
                    foreach (KeyValuePair<string, object> param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
                    }
                }

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    result = "1";
                }
                catch (Exception ex)
                {
                    result = "-1";
                    throw ex;
                }
            }
        }

        return result;
    }

    public DataTable GetDataTable(string connectionStringName, string commandText, Dictionary<string, object> parameters, bool isStoredProcedure)
    {
        string connName = string.IsNullOrEmpty(connectionStringName) ? DefaultConnName : connectionStringName;
        string connectionString = ConfigurationManager.ConnectionStrings[connName].ConnectionString;
        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(commandText, con))
            {
                cmd.CommandType = isStoredProcedure ? CommandType.StoredProcedure : CommandType.Text;
                cmd.CommandTimeout = 120;

                if (parameters != null)
                {
                    foreach (KeyValuePair<string, object> param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
                    }
                }

                try
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dt);
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        return dt;
    }

    public void BindGridView(string connectionStringName, string storedProcedureName, Dictionary<string, object> parameters, GridView gv)
    {
        try
        {
            DataTable dt = GetDataTable(connectionStringName, storedProcedureName, parameters, true);
            gv.DataSource = dt;
            gv.DataBind();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public void BindRepeater(string connectionStringName, string storedProcedureName, Dictionary<string, object> parameters, Repeater rpt)
    {
        try
        {
            DataTable dt = GetDataTable(connectionStringName, storedProcedureName, parameters, true);
            rpt.DataSource = dt;
            rpt.DataBind();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public void BindDropDownList(string connectionStringName, string storedProcedureName, Dictionary<string, object> parameters, DropDownList ddl, string textField, string valueField, string defaultText = "هەڵبژێرە...")
    {
        try
        {
            DataTable dt = GetDataTable(connectionStringName, storedProcedureName, parameters, true);
            ddl.DataSource = dt;
            ddl.DataTextField = textField;
            ddl.DataValueField = valueField;
            ddl.DataBind();

            if (!string.IsNullOrEmpty(defaultText))
            {
                ddl.Items.Insert(0, new ListItem(defaultText, "0"));
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
