

class EnterpriseModel {
  final String id;
  final String name;
  final String taxCode;
  final String email;
  final String phoneNumber;
  final String industry;
  final String logoUrl;
  final String employeeAmount;
  final String address;
  final String infomation;
  final int totalFollower;

  EnterpriseModel ({
    required this.id,
    required this.name,
    required this.taxCode,
    required this.email,
    required this.phoneNumber,
    required this.industry,
    required this.logoUrl,
    required this.employeeAmount,
    required this.address,
    required this.infomation,
    required this.totalFollower
  });

  static EnterpriseModel  fromJson(Map<String, dynamic>json) {
    return EnterpriseModel (
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      taxCode: json['tax_code'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      industry: json['industry'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      employeeAmount: json['employee_amount'] ?? '',
      address: json['address'] ?? '',
      infomation: json['infomation'] ?? '',
      totalFollower: json['total_followers'] ?? 0
    );
  }
}