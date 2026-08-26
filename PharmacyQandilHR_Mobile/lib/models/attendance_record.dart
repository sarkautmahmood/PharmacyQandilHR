class AttendanceRecord {
  final int attendanceId;
  final int checkType; // 1: In, 2: Out
  final String checkDateTime;
  final double distanceMeters;
  final String selfieImagePath;
  final int status; // 1: OnTime, 2: Late
  final String statusName;

  AttendanceRecord({
    required this.attendanceId,
    required this.checkType,
    required this.checkDateTime,
    required this.distanceMeters,
    required this.selfieImagePath,
    required this.status,
    required this.statusName,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      attendanceId: json['Attendance_ID'] ?? 0,
      checkType: json['CheckType'] ?? 1,
      checkDateTime: json['CheckDateTime'] ?? '',
      distanceMeters: (json['DistanceMeters'] != null) ? double.parse(json['DistanceMeters'].toString()) : 0.0,
      selfieImagePath: json['SelfieImagePath'] ?? '',
      status: json['Status'] ?? 1,
      statusName: json['StatusName'] ?? 'لە کاتدا',
    );
  }

  bool get isIn => checkType == 1;
}
