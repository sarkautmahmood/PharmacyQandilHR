import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employee_model.dart';

class PayrollSlipScreen extends StatelessWidget {
  final EmployeeModel employee;

  const PayrollSlipScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("وەسڵی مووچەی مانگانە"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Salary Summary Card
            Card(
              color: AppTheme.primaryDarkTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    const Text(
                      "کۆی گشتی مووچەی وەرگیراو (مانگی ٧)",
                      style: TextStyle(color: AppTheme.accentMint, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "١,٠٦٠,٠٠٠ دینار",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text("دراوە بە تەواوی", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("وردەکاری مووچە و شایستە داراییەکان", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Divider(height: 24),
                    _buildRow("مووچەی بنەڕەتی (Base Salary)", "٩٥٠,٠٠٠ دینار", isBold: true),
                    _buildRow("ڕۆژانی ئامادەبوون", "٢٦ ڕۆژ"),
                    _buildRow("پاداشتی دەوام و فرۆش", "+ ٥٠,٠٠٠ دینار", color: AppTheme.successGreen),
                    _buildRow("کاتژمێری زیادە (Overtime)", "+ ٦٠,٠٠٠ دینار", color: AppTheme.successGreen),
                    _buildRow("بڕینەکان و سزا", "٠ دینار", color: AppTheme.textMuted),
                    const Divider(height: 24),
                    _buildRow("کۆی گشتی ماوە (Net Total)", "١,٠٦٠,٠٠٠ دینار", isBold: true, color: AppTheme.primaryTeal, fontSize: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isBold = false, Color? color, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: AppTheme.textDark, fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(color: color ?? AppTheme.textDark, fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}
