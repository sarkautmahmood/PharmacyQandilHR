import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employee_model.dart';
import '../../services/portal_service.dart';

class LeaveRequestScreen extends StatefulWidget {
  final EmployeeModel employee;

  const LeaveRequestScreen({super.key, required this.employee});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  int _selectedLeaveType = 1;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  final Map<int, String> _leaveTypes = {
    1: "مۆڵەتی ئاسایی (ساڵانە)",
    2: "مۆڵەتی نەخۆشی",
    3: "مۆڵەتی بەپەلە",
    4: "مۆڵەتی بێ مووچە",
  };

  Future<void> _submitRequest() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تکایە هۆکاری مۆڵەت بنووسە.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await PortalService.submitLeaveRequest(
      empId: widget.employee.empId,
      leaveTypeId: _selectedLeaveType,
      startDate: _startDate.toString().split(' ')[0],
      endDate: _endDate.toString().split(' ')[0],
      reason: _reasonController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['Success'] == true) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 50),
          title: const Text("داواکاری مۆڵەت نێردرا"),
          content: Text(result['Message'] ?? "داواکارییەکەت گەیشتە بەڕێوەبەر."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text("تەواو"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['Message'] ?? "هەڵە لە ناردنی داواکاری.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int daysCount = _endDate.difference(_startDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("داواکردنی مۆڵەت"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type Selection
            const Text("جۆری مۆڵەت", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedLeaveType,
                  isExpanded: true,
                  items: _leaveTypes.entries.map((e) {
                    return DropdownMenuItem(value: e.key, child: Text(e.value));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedLeaveType = val!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date Range Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("لە بەرواری", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              _startDate.toString().split(' ')[0],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLightTeal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "$daysCount ڕۆژ",
                            style: const TextStyle(color: AppTheme.primaryTeal, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("تا بەرواری", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              _endDate.toString().split(' ')[0],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reason Text Area
            const Text("هۆکاری مۆڵەت", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "هۆکاری مۆڵەتەکەت بە کورتی بنووسە...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryTeal, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("ناردنی داواکاری بۆ بەڕێوەبەر", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
