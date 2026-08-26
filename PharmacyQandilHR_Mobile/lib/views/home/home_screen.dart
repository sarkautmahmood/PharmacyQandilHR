import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/geofence_calculator.dart';
import '../../models/employee_model.dart';
import '../attendance/attendance_history_screen.dart';
import '../attendance/live_selfie_camera_screen.dart';
import '../leaves/leave_request_screen.dart';
import '../payroll/payroll_slip_screen.dart';
import '../shifts/shifts_screen.dart';

class HomeScreen extends StatefulWidget {
  final EmployeeModel employee;

  const HomeScreen({super.key, required this.employee});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Live GPS Distance simulation / Live tracker (e.g. 8.5 meters inside branch)
  double _currentDistance = 8.5;
  final int _allowedRadius = 50;

  bool get _isInsideGeofence => _currentDistance <= _allowedRadius;

  void _openCamera(int checkType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveSelfieCameraScreen(
          employee: widget.employee,
          checkType: checkType,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        // Refresh local status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("دەرمانخانەکانی قەندیل"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pharmacist Profile Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryDarkTeal, Color(0xFF115E59)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryDarkTeal.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accentMint, width: 2),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 34),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.employee.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.employee.jobTitle ?? "دەرمانساز",
                          style: const TextStyle(color: AppTheme.accentMint, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.storefront, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.employee.placeName,
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Geofencing GPS Radar Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (_isInsideGeofence ? AppTheme.successGreen : AppTheme.dangerRed).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isInsideGeofence ? Icons.near_me_rounded : Icons.location_off_rounded,
                            color: _isInsideGeofence ? AppTheme.successGreen : AppTheme.dangerRed,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isInsideGeofence ? "لە ناو بازنەی دەرمانخانەکەیت" : "لە دەرەوەی دەرمانخانەیت",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _isInsideGeofence ? AppTheme.successGreen : AppTheme.dangerRed,
                                ),
                              ),
                              Text(
                                "مەودای ئێستات: ${GeofenceCalculator.formatDistanceKurdish(_currentDistance)} (سنوور: $_allowedRadius مەتر)",
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Big Action Buttons: Check-In & Check-Out
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openCamera(1), // 1: In
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt_rounded, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "تۆماری هاتن\n(Check-In)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openCamera(2), // 2: Out
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.dangerRed,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.exit_to_app_rounded, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "تۆماری چوون\n(Check-Out)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Quick Menu Services
            const Text(
              "خزمەتگوزارییەکانی کارمەند",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.history_rounded,
                    title: "مێژووی دەوام",
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AttendanceHistoryScreen(employee: widget.employee)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.calendar_month_rounded,
                    title: "شیفتەکانم",
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ShiftsScreen(employee: widget.employee)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.event_busy_rounded,
                    title: "داواکردنی مۆڵەت",
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LeaveRequestScreen(employee: widget.employee)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.account_balance_wallet_rounded,
                    title: "وەسڵی مووچە",
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PayrollSlipScreen(employee: widget.employee)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
