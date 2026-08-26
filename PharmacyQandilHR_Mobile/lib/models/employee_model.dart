class EmployeeModel {
  final int empId;
  final String fullName;
  final int placeId;
  final String placeName;
  final String? jobTitle;
  final String? phone;
  final String? email;
  final String? deviceUuid;
  final double baseSalary;
  final bool isActive;

  EmployeeModel({
    required this.empId,
    required this.fullName,
    required this.placeId,
    required this.placeName,
    this.jobTitle,
    this.phone,
    this.email,
    this.deviceUuid,
    required this.baseSalary,
    required this.isActive,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      empId: json['Emp_ID'] ?? 0,
      fullName: json['FullName'] ?? '',
      placeId: json['Places_ID'] ?? 0,
      placeName: json['Places_Name'] ?? 'دەرمانخانەی سەرەکی',
      jobTitle: json['JobTitle'],
      phone: json['Phone'],
      email: json['Email'],
      deviceUuid: json['DeviceUUID'],
      baseSalary: (json['BaseSalary'] != null) ? double.parse(json['BaseSalary'].toString()) : 0.0,
      isActive: json['IsActive'] == 1 || json['IsActive'] == true,
    );
  }
}
