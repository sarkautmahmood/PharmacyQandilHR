using System;
using System.Data;
using System.Data.SqlClient;

class TestKurdish
{
    static void Main()
    {
        string cs = "Server=.;Database=PharmacyQandilDB;Integrated Security=True;TrustServerCertificate=True;";
        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();

            // Test inserting a new employee with special Kurdish letters (پ، چ، گ، ژ، ڤ، ڕ، ڵ، ە، ێ، ۆ)
            using (SqlCommand cmd = new SqlCommand("HR_Employees_Insert", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@user_insert", SqlDbType.Int).Value = 1;
                cmd.Parameters.Add("@Places_ID", SqlDbType.Int).Value = 1;
                cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 250).Value = "د. پەروین عەلی مەحموود - دەرمانسازی پسپۆڕ";
                cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 50).Value = "07709998877";
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 150).Value = "parwin@pharmacyqandil.com";
                cmd.Parameters.Add("@DeviceUUID", SqlDbType.NVarChar, 250).Value = "DEV-TEST-KURDISH";
                cmd.Parameters.Add("@BaseSalary", SqlDbType.Decimal).Value = 980000.00m;
                cmd.Parameters.Add("@HireDate", SqlDbType.Date).Value = DateTime.Now.Date;
                cmd.Parameters.Add("@IsActive", SqlDbType.TinyInt).Value = 1;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar, 500).Value = "تێبینی: پشکنینی پیتە تایبەتەکانی کوردی (پ، چ، گ، ژ، ڤ، ڕ، ڵ، ە، ێ، ۆ)";

                SqlParameter outParam = new SqlParameter("@ErrorMessage", SqlDbType.VarChar, 50);
                outParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(outParam);

                cmd.ExecuteNonQuery();

                Console.WriteLine("Insert SP Result: " + outParam.Value.ToString());
            }

            // Retrieve all employees and print with Console Encoding UTF-8
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            using (SqlCommand cmd = new SqlCommand("HR_Employees_SelectAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    Console.WriteLine("\n--- LIST OF EMPLOYEES IN DATABASE ---");
                    while (reader.Read())
                    {
                        Console.WriteLine(string.Format("ID: {0} | Name: {1} | Branch: {2} | Notes: {3}",
                            reader["Emp_ID"], reader["FullName"], reader["Places_Name"], reader["Notes"]));
                    }
                }
            }
        }
    }
}
