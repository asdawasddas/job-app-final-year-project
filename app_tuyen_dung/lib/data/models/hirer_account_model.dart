
// is blocked 0 1 2
// 0: chưa chọn doanh nghiệp, 1: đã chọn, chờ xác nhận, 2: đã xác nhận
class HirerAccountModel{
  String id;
  String fullName;
  String email;
  String phoneNumber;
  String avatarUrl;
  int isConfirmed;
  bool isBlocked;
  String enterpriseId;

  HirerAccountModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.isConfirmed,
    required this.isBlocked,
    required this.enterpriseId,

  });

  String get status {
    if (isBlocked) {
      return 'Bị chặn';
    } else {
      switch (isConfirmed) {
        case 0: return 'Vô danh';
        case 1: return 'Chờ xác nhận';
        case 2: return 'Xác nhận';
        default : return 'Vô danh';
      }
    }
  }

  int get statusInt {
    if (isBlocked) {
      return 3;
    } else {
      switch (isConfirmed) {
        case 0: return 0;
        case 1: return 1;
        case 2: return 2;
        default : return 0;
      }
    }
  }

  static HirerAccountModel fromJson(Map<String, dynamic>json) {
    return HirerAccountModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      isConfirmed: json['is_confirmed'] ?? 0,
      isBlocked: json['is_blocked'] ?? false,
      enterpriseId: json['enterprise_id'] ?? '',
    );
  }
  
}