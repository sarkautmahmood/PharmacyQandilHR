class ShiftModel {
  final int empShiftId;
  final String shiftDate;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String placeName;

  ShiftModel({
    required this.empShiftId,
    required this.shiftDate,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.placeName,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      empShiftId: json['EmpShift_ID'] ?? 0,
      shiftDate: json['ShiftDate'] ?? '',
      shiftName: json['ShiftName'] ?? '',
      startTime: json['StartTime'] ?? '',
      endTime: json['EndTime'] ?? '',
      placeName: json['Places_Name'] ?? '',
    );
  }
}

class LeaveModel {
  final int leaveId;
  final String typeName;
  final String startDate;
  final String endDate;
  final double totalDays;
  final String? reason;
  final int status; // 1: Pending, 2: Approved, 3: Rejected
  final String statusName;

  LeaveModel({
    required this.leaveId,
    required this.typeName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    this.reason,
    required this.status,
    required this.statusName,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      leaveId: json['Leave_ID'] ?? 0,
      typeName: json['TypeName'] ?? '',
      startDate: json['StartDate'] ?? '',
      endDate: json['EndDate'] ?? '',
      totalDays: (json['TotalDays'] != null) ? double.parse(json['TotalDays'].toString()) : 1.0,
      reason: json['Reason'],
      status: json['Status'] ?? 1,
      statusName: json['StatusName'] ?? 'چاوەڕوان',
    );
  }
}
