class AppUrl {
  static const String liveBaseURL = "http://47.74.17.218/api";
  // static const String localBaseURL = "http://api.parking-lot.local:8081/api";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/login";
  static const String register = baseURL + "/registration";
  static const String forgotPassword = baseURL + "/forgot-password";
}