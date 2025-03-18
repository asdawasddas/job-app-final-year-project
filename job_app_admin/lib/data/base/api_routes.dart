class ApiRoutes {
  static String baseUrl = 'http://127.0.0.1:8000/';
  // static String BASE_URL = 'http://10.0.2.2:8000';
  // static String baseUrl = 'http://192.168.1.5:8000/';
  
  // Admin
  static String admins = '$baseUrl/admins/';
  static String login = "$baseUrl/admins/login/";
  static String adminInfo(String adminId) {
    return "$baseUrl/admins/$adminId/";
  }
  static String adminChangePassword(String adminId) {
    return "$baseUrl/admins/$adminId/changePassword/";
  }

  // Enterprise
  static String enterprises = "$baseUrl/enterprises/";
  static String enterpriseInfo(String id) {
    return "$baseUrl/enterprises/$id/";
  }


  // Hirer
  static String hirers = '$baseUrl/hirers/';
  static String hirerInfo(String id) {
    return "$hirers$id/";
  }

  // Applicant
  static String applicants = '$baseUrl/applicants/';
  static String applicantInfo(String id) {
    return "$applicants$id/";
  }

  static String jobs = "$baseUrl/jobs/";
  static String jobDetail(String jobId){
    return '$baseUrl/jobs/$jobId/';
  }



  // static const POSITIONS = "$_API/meta/get_all_job_titles";
  // static const SEARCH = "$_API/companies/search";
  // static const COMPANIES = "$_API/companies/";
  // static const COMPANY_REGISTER = "$_API/auth/company_signup";
  // static const CUSTOMER_REGISTER = "$_API/auth/customer_signup";
  // static const LOGIN = "$_API/auth/login";
  // static const CUSTOMERS = "$_API/customers";
  // static const SAVED_JOBS = "$CUSTOMERS/get_all_saved_jobs/";
  // static const TOGGLE_SAVE = "$CUSTOMERS/save/";
  // static const APPLICATIONS = "$_API/applications/";
  // static const JOB_APPLY = "$CUSTOMERS/Aplly/";
}