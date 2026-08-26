using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;

/// <summary>
/// SOAP Web Service for Employee Attendance, Geofencing GPS Verification, and Live Selfie Uploads
/// </summary>
[WebService(Namespace = "http://pharmacyqandil.com/hr/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class HR_AttendanceService : System.Web.Services.WebService
{
    private Fun_DataHelper _db = new Fun_DataHelper();

    public class AttendanceResult
    {
        public bool Success { get; set; }
        public string StatusCode { get; set; }
        public string Message { get; set; }
        public double DistanceInMeters { get; set; }
        public string CheckDateTime { get; set; }
        public string StatusName { get; set; }
    }

    /// <summary>
    /// Processes Employee Attendance Check-In / Check-Out with GPS Geofencing and Live Selfie
    /// </summary>
    [WebMethod(Description = "Record employee attendance with GPS validation and Selfie image")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public AttendanceResult Check_Attendance(int empID, int placeID, byte checkType, double latitude, double longitude, string selfieBase64, string deviceUUID)
    {
        AttendanceResult result = new AttendanceResult();

        try
        {
            // 1. Verify Employee Existence and Device UUID
            var empParams = new Dictionary<string, object> { { "@Emp_ID", empID } };
            DataTable dtEmp = _db.GetDataTable("PharmacyQandilDB", "HR_Employees_selectID", empParams, true);

            if (dtEmp.Rows.Count == 0)
            {
                result.Success = false;
                result.StatusCode = "EMP_NOT_FOUND";
                result.Message = "کارمەند لە سیستەمدا نەدۆزرایەوە.";
                return result;
            }

            DataRow empRow = dtEmp.Rows[0];
            bool isActive = Convert.ToInt32(empRow["IsActive"]) == 1;
            if (!isActive)
            {
                result.Success = false;
                result.StatusCode = "EMP_INACTIVE";
                result.Message = "هەژماری کارمەند ناچالاک کراوە.";
                return result;
            }

            string registeredDevice = empRow["DeviceUUID"] != DBNull.Value ? empRow["DeviceUUID"].ToString() : "";
            if (!string.IsNullOrEmpty(registeredDevice) && !registeredDevice.Equals(deviceUUID, StringComparison.OrdinalIgnoreCase))
            {
                result.Success = false;
                result.StatusCode = "INVALID_DEVICE";
                result.Message = "ئەم مۆبایلە ڕێگەپێنەدراوە. تەنها لە مۆبایلی فەرمی خۆت دەتوانی دەوام لێبدەی.";
                return result;
            }

            // 2. Retrieve Pharmacy Branch GPS Location
            var gpsParams = new Dictionary<string, object> { { "@Places_ID", placeID } };
            DataTable dtGps = _db.GetDataTable("PharmacyQandilDB", "SELECT * FROM dbo.tblPlaces_GPS WHERE Places_ID = @Places_ID AND IsActive = 1", gpsParams, false);

            double targetLat = 35.565800;
            double targetLng = 45.421500;
            int allowedRadius = 50; // default 50 meters

            if (dtGps.Rows.Count > 0)
            {
                targetLat = Convert.ToDouble(dtGps.Rows[0]["Latitude"]);
                targetLng = Convert.ToDouble(dtGps.Rows[0]["Longitude"]);
                allowedRadius = Convert.ToInt32(dtGps.Rows[0]["AllowedRadiusMeters"]);
            }

            // 3. Calculate Haversine Distance
            double distanceMeters = GeofencingHelper.CalculateDistanceInMeters(latitude, longitude, targetLat, targetLng);
            result.DistanceInMeters = Math.Round(distanceMeters, 2);

            if (distanceMeters > allowedRadius)
            {
                result.Success = false;
                result.StatusCode = "OUT_OF_GEOFENCE";
                result.Message = string.Format("تۆ لە دەرەوەی بازنەی دەرمانخانەکەیت! مەودای ئێستات: {0:F1} مەترە (مەودای ڕێگەپێدراو {1} مەترە).", distanceMeters, allowedRadius);
                return result;
            }

            // 4. Save Selfie Image to Server
            string selfiePath = "Uploads/AttendanceSelfies/default_avatar.jpg";
            if (!string.IsNullOrEmpty(selfieBase64))
            {
                try
                {
                    string cleanBase64 = selfieBase64;
                    if (cleanBase64.Contains(","))
                    {
                        cleanBase64 = cleanBase64.Substring(cleanBase64.IndexOf(",") + 1);
                    }

                    byte[] imageBytes = Convert.FromBase64String(cleanBase64);
                    string dateFolder = DateTime.Now.ToString("yyyy_MM_dd");
                    string physicalFolder = HttpContext.Current.Server.MapPath("~/Uploads/AttendanceSelfies/" + dateFolder);

                    if (!Directory.Exists(physicalFolder))
                    {
                        Directory.CreateDirectory(physicalFolder);
                    }

                    string fileName = string.Format("Emp_{0}_{1}_{2}.jpg", empID, DateTime.Now.ToString("HHmmss"), Guid.NewGuid().ToString().Substring(0, 5));
                    string physicalPath = Path.Combine(physicalFolder, fileName);
                    File.WriteAllBytes(physicalPath, imageBytes);

                    selfiePath = string.Format("Uploads/AttendanceSelfies/{0}/{1}", dateFolder, fileName);
                }
                catch (Exception)
                {
                    selfiePath = "Uploads/AttendanceSelfies/sample_selfie_1.jpg";
                }
            }

            // 5. Determine On-Time vs Late Status
            byte status = 1; // 1: OnTime, 2: Late
            string statusName = "لە کاتی خۆیدا (On Time)";

            // Check shift timing
            var shiftParams = new Dictionary<string, object>
            {
                { "@Emp_ID", empID },
                { "@ShiftDate", DateTime.Now.Date }
            };
            DataTable dtShift = _db.GetDataTable("PharmacyQandilDB", "SELECT s.* FROM dbo.tblHR_EmployeeShifts es INNER JOIN dbo.tblHR_Shifts s ON es.Shift_ID = s.Shift_ID WHERE es.Emp_ID = @Emp_ID AND es.ShiftDate = @ShiftDate", shiftParams, false);

            if (dtShift.Rows.Count > 0 && checkType == 1) // Check-In
            {
                string startTimeStr = dtShift.Rows[0]["StartTime"].ToString();
                int lateGrace = Convert.ToInt32(dtShift.Rows[0]["LateGraceMinutes"]);

                TimeSpan shiftStart;
                if (TimeSpan.TryParse(startTimeStr, out shiftStart))
                {
                    TimeSpan graceLimit = shiftStart.Add(TimeSpan.FromMinutes(lateGrace));
                    if (DateTime.Now.TimeOfDay > graceLimit)
                    {
                        status = 2; // Late
                        statusName = "دواکەوتوو (Late)";
                    }
                }
            }

            // 6. Insert Attendance Record via Stored Procedure
            var insertParams = new Dictionary<string, object>
            {
                { "@user_insert", 1 },
                { "@Emp_ID", empID },
                { "@Place_ID", placeID },
                { "@CheckType", checkType },
                { "@CheckDateTime", DateTime.Now },
                { "@Latitude", latitude },
                { "@Longitude", longitude },
                { "@DistanceMeters", distanceMeters },
                { "@SelfieImagePath", selfiePath },
                { "@DeviceUUID", deviceUUID },
                { "@Status", status },
                { "@Notes", checkType == 1 ? "تۆماری دەوامی هاتن لە ڕێگەی مۆبایل" : "تۆماری دەوامی چوون لە ڕێگەی مۆبایل" }
            };

            string spResult = _db.ExecuteSP("PharmacyQandilDB", "HR_Attendance_Insert", insertParams);

            if (spResult == "1")
            {
                result.Success = true;
                result.StatusCode = "SUCCESS";
                result.CheckDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                result.StatusName = statusName;
                result.Message = checkType == 1
                    ? "دەوامی هاتن بە سەرکەوتوویی تۆمارکرا. ڕۆژێکی پڕ لە بەرەکەت!"
                    : "دەوامی چوون بە سەرکەوتوویی تۆمارکرا. ماندوو نەبیت!";
            }
            else
            {
                result.Success = false;
                result.StatusCode = "DB_ERROR";
                result.Message = "هەڵە لە پاشەکەوتکردنی داتا لە داتابەیس.";
            }
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.StatusCode = "EXCEPTION";
            result.Message = "کێشە ڕوویدا: " + ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Gets today's attendance summary for the given employee
    /// </summary>
    [WebMethod(Description = "Get today attendance logs for employee")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public DataTable Get_Today_Attendance_Logs(int empID)
    {
        var parameters = new Dictionary<string, object>
        {
            { "@Emp_ID", empID },
            { "@Today", DateTime.Now.Date }
        };

        string sql = @"
            SELECT Attendance_ID, CheckType, CheckDateTime, DistanceMeters, Status, SelfieImagePath,
                   CASE WHEN CheckType = 1 THEN N'هاتن (Check-In)' ELSE N'چوون (Check-Out)' END AS CheckTypeName,
                   CASE WHEN Status = 1 THEN N'لە کاتدا' WHEN Status = 2 THEN N'دواکەوتوو' ELSE N'ئاسایی' END AS StatusName
            FROM dbo.tblHR_Attendance
            WHERE Emp_ID = @Emp_ID AND CONVERT(date, CheckDateTime) = @Today
            ORDER BY CheckDateTime DESC;";

        return _db.GetDataTable("PharmacyQandilDB", sql, parameters, false);
    }
}
