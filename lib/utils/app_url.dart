class AppUrl {
  static const String liveBaseURL = "http://47.74.17.218/api";
  static const String localBaseURL = "http://192.168.3.20:8081/api";
  static const String webBaseURL = "http://47.74.43.232";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/login";
  static const String register = baseURL + "/registration";
  static const String forgotPassword = baseURL + "/forgot-password";
  static const String getDatatable = webBaseURL + "/permissions/datatable";
}