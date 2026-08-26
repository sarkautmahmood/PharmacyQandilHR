import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employee_model.dart';
import '../../models/shift_model.dart';

class ShiftsScreen extends StatelessWidget {
  final EmployeeModel employee;

  const ShiftsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final List<ShiftModel> shifts = [
      ShiftModel(
        empShiftId: 1,
        shiftDate: "2026-08-26 (ئەمڕۆ)",
        shiftName: "شیفتی بەیانیان",
        startTime: "08:00",
        endTime: "16:00",
        placeName: employee.placeName,
      ),
      ShiftModel(
        empShiftId: 2,
        shiftDate: "2026-08-27 (سبەی)",
        shiftName: "شیفتی بەیانیان",
        startTime: "08:00",
        endTime: "16:00",
        placeName: employee.placeName,
      ),
      ShiftModel(
        empShiftId: 3,
        shiftDate: "2026-08-28 (دووسبەی)",
        shiftName: "شیفتی ئێواران",
        startTime: "16:00",
        endTime: "00:00",
        placeName: employee.placeName,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("خشتەی شیفتەکانی دەرمانخانە"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shifts.length,
        itemBuilder: (context, index) {
          final s = shifts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLightTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.schedule_rounded, color: AppTheme.primaryTeal, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.shiftDate,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.shiftName,
                          style: const TextStyle(color: AppTheme.primaryTeal, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.placeName,
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDarkTeal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${s.startTime} - ${s.endTime}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
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
