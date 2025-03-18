
class JobSearchModel {
  String title;
  String workingType;
  List occupations;
  List areas;
  String position;
  String experience;
  String salary;
  String sort;


  JobSearchModel({
    required this.title,
    required this.workingType,
    required this.occupations,
    required this.areas,
    required this.position,
    required this.experience,
    required this.salary,
    required this.sort,
  });

  String get seartchTxt {
    String occ = occupations.join('#');
    String area = areas.join('#');
    if (position == 'Tất cả') {
      position = '';
    }
    if (workingType == 'Tất cả') {
      workingType = '';
    } 
    if (sort == 'Liên quan nhất') {
      sort = '0';
    }
    if (sort == 'Mới nhất') {
      sort = '1';
    }
    return 'title=$title&wt=$workingType&occ=$occ&ps=$position&exp=$experience&areas=$area&salary=$salary&sort=$sort';
  }

  static JobSearchModel fromJson(Map<String, dynamic> json) {
    return JobSearchModel(
      title: json['title'] ?? '',
      workingType: json['workingType'] ?? '',
      occupations: json['occupations'] ?? [],
      areas: json['areas'] ?? [],
      position: json['position'] ?? '',
      experience: json['experience'] ?? '',
      salary: json['salary'] ?? '',
      sort: json['sort'] ?? '',
    );
  }
}