
// is blocked 0 1 2
// 0: chưa chọn doanh nghiệp, 1: đã chọn, chờ xác nhận, 2: đã xác nhận
class HirerModel{
  String id;
  String fullName;
  String email;
  String phoneNumber;
  String avatarUrl;
  int isConfirmed;
  bool isBlocked;
  String enterpriseId;

  HirerModel({
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
      return 'Đang bị chặn';
    } else {
      switch (isConfirmed) {
        case 0: return 'Chưa cập nhật';
        case 1: return 'Chờ xác nhận';
        case 2: return 'Đã xác nhận';
        default : return 'Chưa cập nhật';
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

  static HirerModel fromJson(Map<String, dynamic>json) {
    return HirerModel(
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