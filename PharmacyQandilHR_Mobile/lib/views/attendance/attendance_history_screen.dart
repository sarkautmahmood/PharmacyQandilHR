import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/attendance_record.dart';
import '../../models/employee_model.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final EmployeeModel employee;

  const AttendanceHistoryScreen({super.key, required this.employee});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  // Sample local attendance records for instant display
  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      attendanceId: 101,
      checkType: 1,
      checkDateTime: "2026-08-26 08:02:15",
      distanceMeters: 4.2,
      selfieImagePath: "Uploads/AttendanceSelfies/sample_selfie_1.jpg",
      status: 1,
      statusName: "لە کاتدا",
    ),
    AttendanceRecord(
      attendanceId: 100,
      checkType: 2,
      checkDateTime: "2026-08-25 16:05:20",
      distanceMeters: 6.8,
      selfieImagePath: "Uploads/AttendanceSelfies/sample_selfie_1.jpg",
      status: 1,
      statusName: "تەواوبوونی دەوام",
    ),
    AttendanceRecord(
      attendanceId: 99,
      checkType: 1,
      checkDateTime: "2026-08-25 08:18:10",
      distanceMeters: 12.5,
      selfieImagePath: "Uploads/AttendanceSelfies/sample_selfie_1.jpg",
      status: 2,
      statusName: "١٨ خولەک دواکەوتوو",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مێژووی دەوامی من"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final rec = _records[index];
          final isOnTime = rec.status == 1;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: rec.isIn ? AppTheme.successGreen.withOpacity(0.12) : AppTheme.dangerRed.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      rec.isIn ? Icons.login_rounded : Icons.logout_rounded,
                      color: rec.isIn ? AppTheme.successGreen : AppTheme.dangerRed,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.isIn ? "تۆماری هاتن (Check-In)" : "تۆماری چوون (Check-Out)",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rec.checkDateTime,
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppTheme.primaryTeal),
                            const SizedBox(width: 4),
                            Text(
                              "مەودا: ${rec.distanceMeters.toStringAsFixed(1)} مەتر",
                              style: const TextStyle(fontSize: 12, color: AppTheme.primaryTeal, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isOnTime ? AppTheme.successGreen.withOpacity(0.12) : AppTheme.warningOrange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      rec.statusName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOnTime ? AppTheme.successGreen : AppTheme.warningOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
