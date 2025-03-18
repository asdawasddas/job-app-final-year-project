

class EnterpriseModel {
  String id;
  String name;
  String taxCode;
  String email;
  String phoneNumber;
  String industry;
  String logoUrl;
  String employeeAmount;
  String address;
  String infomation;


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
    required this.infomation
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
    );
  }
}