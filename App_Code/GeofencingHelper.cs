using System;

/// <summary>
/// Geofencing math helper for calculating distance between GPS coordinates in meters
/// </summary>
public static class GeofencingHelper
{
    private const double EarthRadiusMeters = 6371000.0;

    /// <summary>
    /// Calculates the great-circle distance between two points on the Earth surface using the Haversine formula
    /// </summary>
    /// <param name="lat1">Latitude of Point 1</param>
    /// <param name="lon1">Longitude of Point 1</param>
    /// <param name="lat2">Latitude of Point 2 (Pharmacy branch)</param>
    /// <param name="lon2">Longitude of Point 2 (Pharmacy branch)</param>
    /// <returns>Distance in meters</returns>
    public static double CalculateDistanceInMeters(double lat1, double lon1, double lat2, double lon2)
    {
        double dLat = ToRadians(lat2 - lat1);
        double dLon = ToRadians(lon2 - lon1);

        double rLat1 = ToRadians(lat1);
        double rLat2 = ToRadians(lat2);

        double a = Math.Sin(dLat / 2.0) * Math.Sin(dLat / 2.0) +
                   Math.Sin(dLon / 2.0) * Math.Sin(dLon / 2.0) * Math.Cos(rLat1) * Math.Cos(rLat2);

        double c = 2.0 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1.0 - a));

        return EarthRadiusMeters * c;
    }

    private static double ToRadians(double degrees)
    {
        return degrees * (Math.PI / 180.0);
    }
}
