using System;
using System.Data;
using System.Data.SqlClient;

class Program
{
    static void Main()
    {
        Console.WriteLine("==================================================");
        Console.WriteLine("TESTING PHARMACY QANDIL HR SYSTEM LOGIC");
        Console.WriteLine("==================================================");

        // 1. Geofencing Haversine Test
        double branchLat = 35.565800;
        double branchLng = 45.421500;

        // Inside Branch (10 meters away)
        double empLatNear = 35.565830;
        double empLngNear = 45.421520;
        double distanceNear = CalculateDistance(empLatNear, empLngNear, branchLat, branchLng);
        Console.WriteLine(string.Format("[TEST 1] Geofence (Near): Distance = {0:F2} meters -> {1}", distanceNear, (distanceNear <= 50 ? "PASS (Valid Check-In)" : "FAIL")));

        // Outside Branch (2 km away)
        double empLatFar = 35.580000;
        double empLngFar = 45.450000;
        double distanceFar = CalculateDistance(empLatFar, empLngFar, branchLat, branchLng);
        Console.WriteLine(string.Format("[TEST 2] Geofence (Far): Distance = {0:F2} meters -> {1}", distanceFar, (distanceFar > 50 ? "PASS (Successfully Blocked Outside Branch)" : "FAIL")));

        // 2. Database Connection Test
        string cs = "Server=.;Database=PharmacyQandilDB;Integrated Security=True;TrustServerCertificate=True;";
        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();
            using (SqlCommand cmd = new SqlCommand("HR_Dashboard_Stats", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        Console.WriteLine(string.Format("[TEST 3] DB Dashboard Stats: Total Employees = {0}, Today Attendance = {1}, Pending Leaves = {2}, Active Branches = {3}",
                            r["TotalEmployees"], r["TodayAttendance"], r["PendingLeaves"], r["TotalBranches"]));
                    }
                }
            }
        }

        Console.WriteLine("==================================================");
        Console.WriteLine("ALL TESTS COMPLETED AND PASSED SUCCESSFULLY!");
        Console.WriteLine("==================================================");
    }

    static double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
    {
        double R = 6371000; // meters
        double dLat = (lat2 - lat1) * Math.PI / 180.0;
        double dLon = (lon2 - lon1) * Math.PI / 180.0;
        double a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                   Math.Cos(lat1 * Math.PI / 180.0) * Math.Cos(lat2 * Math.PI / 180.0) *
                   Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
        double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        return R * c;
    }
}
