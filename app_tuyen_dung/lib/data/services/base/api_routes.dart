

class ApiRoutes {
  static String baseUrl = 'http://127.0.0.1:8000';
  // static String BASE_URL = 'http://10.0.2.2:8000';
  // static String baseUrl = 'http://192.168.1.5:8000/';

  // static String a = Uri(
  //   scheme: 'http',
  //   host: baseUrl,
  //   path: 'hirer/login/',
  //   queryParameters: {'search': 'blue', 'limit': '10'}
  // ).toString();
  



  // Hirer
  static String login = "$baseUrl/hirers/login/";
  static String signup = "$baseUrl/hirers/signup/";
  static String hirerInfo(String id) {
    return "$baseUrl/hirers/$id/";
  }
  static String hirerAvatar(String id) {
    return "$baseUrl/hirers/$id/avatar/";
  }
  static String hirerLogo(String id) {
    return "$baseUrl/hirers/$id/logo/";
  }
  static String hirerChangePassword(String id) {
    return "$baseUrl/hirers/$id/changePassword/";
  }


  // Enterprise
  static String enterprises = "$baseUrl/enterprises/";
  static String enterpriseInfo(String id) {
    return "$baseUrl/enterprises/$id/";
  }
  static String enterpriseLogo(String id) {
    return "$baseUrl/enterprises/$id/logo/";
  }

  // Jobs
  static String jobs = "$baseUrl/jobs/";
  static String hirerJobs(String id){
    return "$baseUrl/hirers/$id/jobs/";
  }
  static String jobDetail(String jobId){
    return '$baseUrl/jobs/$jobId/';
  }

  // Application
  static String jobApplications(String jobId){
    return '$baseUrl/jobs/$jobId/applications/';
  }
  static String applicationDetail(String applicationId){
    return '$baseUrl/applications/$applicationId/';
  }


  // Statistic
  static String hirerStatistic(String hirerId){
    return "$baseUrl/hirers/$hirerId/statistic/";
  }

}