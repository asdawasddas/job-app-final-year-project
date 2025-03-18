
class ApiRoutes {
  // static String baseUrl = 'http://192.168.1.5:8000/';
  static String baseUrl = 'http://127.0.0.1:8000/';

  // Applicant
  static String login = "$baseUrl/applicants/login/";
  static String signUp = "$baseUrl/applicants/signup/";

  
  static String applicantInfo(String applicantId) {
    return "$baseUrl/applicants/$applicantId/";
  }

  static String applicantAvatar(String applicantId) {
    return "$baseUrl/applicants/$applicantId/avatar/";
  }

  static String applicantChangePassword(String applicantId) {
    return "$baseUrl/applicants/$applicantId/changePassword/";
  }

  static String applicantFavEnterprise(String applicantId) {
    return "$baseUrl/applicants/$applicantId/favEnterprises/";
  }

  static String applicantFavJob(String applicantId) {
    return "$baseUrl/applicants/$applicantId/favJobs/";
  }

  static String applicantFavEnterpriseJob(String applicantId) {
    return "$baseUrl/applicants/$applicantId/favEnterprises/jobs";
  }

  static String applicantApplication(String applicantId) {
    return "$baseUrl/applicants/$applicantId/appliedJobs/";
  }

  //Job Application
  static String jobApplication(String jobId) {
    return "$baseUrl/jobs/$jobId/applications/";
  }

  //Job
  static String jobs = "$baseUrl/jobs/";
  static String jobDetail(String jobId) {
    return "$baseUrl/jobs/$jobId/";
  }
  static String similarJob(String jobId) {
    return "$baseUrl/jobs/$jobId/similarJob/";
  }


  // Enterprise
  static String enterprises = "$baseUrl/enterprises/";

  static String enterpriseDetail (String enterpriseId) {
    return "$baseUrl/enterprises/$enterpriseId/";
  }
  static String enterpriseJobs (String enterpriseId) {
    return "$baseUrl/enterprises/$enterpriseId/jobs/";
  }
}