import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employee_model.dart';
import '../../services/attendance_service.dart';

class LiveSelfieCameraScreen extends StatefulWidget {
  final EmployeeModel employee;
  final int checkType; // 1: In, 2: Out

  const LiveSelfieCameraScreen({
    super.key,
    required this.employee,
    required this.checkType,
  });

  @override
  State<LiveSelfieCameraScreen> createState() => _LiveSelfieCameraScreenState();
}

class _LiveSelfieCameraScreenState extends State<LiveSelfieCameraScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      // Look for front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isCameraReady = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("هەڵە لە کردنەوەی کامێرا: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureAndSubmit() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final XFile photo = await _cameraController!.takePicture();
      final File imageFile = File(photo.path);

      final result = await AttendanceService.submitAttendance(
        empId: widget.employee.empId,
        placeId: widget.employee.placeId,
        checkType: widget.checkType,
        selfieImageFile: imageFile,
      );

      if (!mounted) return;

      if (result['Success'] == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 54),
            title: const Text("دەوام بە سەرکەوتوویی تۆمارکرا"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(result['Message'] ?? "دەوام لە سیستەم تۆمارکرا."),
                const SizedBox(height: 10),
                if (result['DistanceInMeters'] != null)
                  Text(
                    "مەودا لە دەرمانخانە: ${result['DistanceInMeters']} مەتر",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                  ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context, true); // return to Home
                },
                child: const Text("تەواو"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.error_outline_rounded, color: AppTheme.dangerRed, size: 54),
            title: const Text("دەوام تۆمار نەکرا!"),
            content: Text(result['Message'] ?? "نەتوانرا دەوام تۆمار بکرێت."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("دووبارە هەوڵبدەرەوە"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("هەڵە ڕوویدا: $e")),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCheckIn = widget.checkType == 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isCheckIn ? "سێڵفی کاتی هاتن (Check-In)" : "سێڵفی کاتی چوون (Check-Out)"),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          // 1. Live Camera Preview
          if (_isCameraReady && _cameraController != null)
            SizedBox.expand(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: AppTheme.accentCyan),
            ),

          // 2. Face Guide Circular Overlay Frame
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCheckIn ? AppTheme.accentCyan : AppTheme.warningOrange,
                  width: 3.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isCheckIn ? AppTheme.accentCyan : AppTheme.warningOrange).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // 3. Top Notice Bar
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.face_retouching_natural, color: AppTheme.accentMint),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "تکایە دەموچاوت لە ناو بازنەکە ڕێکبخە و وێنەی ڕاستەوخۆ بگرە",
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Geotag & Branch Info at bottom
          Positioned(
            bottom: 110,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.accentCyan, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.employee.placeName,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        DateTime.now().toString().substring(0, 19),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 5. Capture Shutter Button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : GestureDetector(
                      onTap: _captureAndSubmit,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: isCheckIn ? AppTheme.accentCyan : AppTheme.warningOrange,
                            width: 5,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 36,
                          color: isCheckIn ? AppTheme.primaryTeal : AppTheme.warningOrange,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
