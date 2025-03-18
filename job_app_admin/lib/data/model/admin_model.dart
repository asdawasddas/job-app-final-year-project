
class Admin {
  String id;
  String accountName;
  String fullName;
  bool isApexAdmin;

  Admin({required this.id, required this.accountName, required this.fullName, required this.isApexAdmin});

  String get type {
    return isApexAdmin ? 'Admin cấp cao' : 'Admin thường';
  }
  static Admin fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? '', 
      accountName: json['account_name'] ?? '', 
      fullName: json['full_name'] ?? '', 
      isApexAdmin: json['is_apex_admin'] ?? false
    );
  }
}