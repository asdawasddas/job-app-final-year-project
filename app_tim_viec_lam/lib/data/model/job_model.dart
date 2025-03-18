

import 'package:intl/intl.dart';

class Job {
  String id;
  String hirerId;
  String enterpriseId;
  String title;
  int minSalary = 0;
  int maxSalary = 0;
  List areas;
  int experience;
  String position;
  int amount;
  String workingType;
  List occupations;
  String descriptions;
  String requirements;
  String benefits;
  String addresses;
  String workingTime;
  String createdDate;
  String expiredDate;
  bool isClosed = false;
  bool ischecked = false;
  int applicationsCount = 0;
  String enterpriseName;
  String logoUrl;

  Job({
    required this.id,
    required this.hirerId,
    required this.enterpriseId,
    required this.title,
    required this.minSalary,
    required this.maxSalary,
    required this.areas,
    required this.experience,
    required this.position,
    required this.amount,
    required this.workingType,
    required this.occupations,
    required this.descriptions,
    required this.requirements,
    required this.benefits,
    required this.addresses,
    required this.workingTime,
    required this.createdDate,
    required this.expiredDate,
    required this.isClosed,
    required this.ischecked,
    required this.applicationsCount,
    required this.enterpriseName,
    required this.logoUrl,
  });

  String get salary {
    if (minSalary == 0 && maxSalary == 0) {
      return 'Thỏa thuận'; 
    } else if (minSalary == 0 && maxSalary > 0) {
      return 'Đến $maxSalary triệu';
    } else if (minSalary > 0 && maxSalary == 0) {
      return 'Tối thiểu $minSalary triệu';
    } else if (minSalary > 0 && maxSalary > 0) {
      return 'Từ $minSalary đến $maxSalary triệu';
    } else {
      return 'Thỏa thuận';
    }
  }

  String get getDate {
    if (isClosed) {
      return 'Đã đóng';
    }
    if (!isClosed && isExpired) {
      return 'Tin hết hạn';
    } else {
      return expiredDate;
    }
  }

  bool get isExpired {
    if (expiredDate == '') {
      return false;
    } else {
      final formatter = DateFormat('dd-MM-yyyy');
      final date = formatter.parse(expiredDate);
      final now = DateTime.now();
      if (date.compareTo(now) < 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  String get exp {
    if (experience <= 0) {
      return 'Không yêu cầu';
    } else {
      return '$experience năm';
    }
  }

  String get area {
    return areas.join(', ');
  }

  String get areasList {
    int length = areas.length;
    if (length < 3) {
      return areas.join(', ');
    } else {
      return '${areas[0]} & ${length - 1} nơi khác';
    }
  }

  static Job fromJson(Map<String, dynamic> json) {
    return Job(
      id : json['id'] ?? '',
      hirerId : json['hirer_id'] ?? '',
      enterpriseId : json['enterprise_id'] ?? '',
      title : json['title'] ?? '',
      minSalary : json['min_salary'] ?? 0,
      maxSalary : json['max_salary'] ?? 0,
      areas : json['areas'] ?? [],
      experience : json['experience'] ?? 0,
      position : json['position'] ?? '',
      amount : json['amount'] ?? 0,
      workingType : json['working_type'] ?? '',
      occupations : json['occupations'] ?? [],
      descriptions : json['descriptions'] ?? '',
      requirements : json['requirements'] ?? '',
      benefits : json['benefits'] ?? '',
      addresses : json['addresses'] ?? '',
      workingTime : json['working_time'] ?? '',
      createdDate : json['created_date'] ?? '',
      expiredDate : json['expired_date'] ?? '',
      isClosed : json['is_closed'] ?? false,
      ischecked : json['is_checked'] ?? false,
      applicationsCount : json['applications_count'] ?? 0,
      enterpriseName : json['enterprise_name'] ?? '',
      logoUrl : json['logo_url'] ?? '',
    );
  }
}