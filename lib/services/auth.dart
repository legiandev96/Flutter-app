import 'dart:async';
import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/services/http_services.dart';
import 'package:flutter_application/utils/app_url.dart';
import 'package:flutter_application/shares/shared_preference.dart';


enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  HttpService httpService = new HttpService();


  Future<Map<String, dynamic>> login(String name, String password) async {

    final Map<String, dynamic> loginData = {
      'account_identifier': name,
      'operating_company_name': "system_administrator",
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    dynamic responseData = await httpService.postMethodNotAuth(
      AppUrl.login,
      loginData
    );
    User authUser;
    if (responseData['status']) {

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    }
    return {
      'status': responseData['status'], 
      'message': responseData['message'], 
      'user': authUser
    };
  }

  Future<Map<String, dynamic>> register(String email, String password, String passwordConfirmation) async {

    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };
    return await post(AppUrl.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  Future<Map<String, dynamic>> getDatatable() async {

    dynamic responseData = await httpService.getMethod(
      AppUrl.getDatatable
    );
    if (responseData['status']) {

    } else {

    }
    return {
      'status': responseData['status'], 
      'message': responseData['message']
    };
  }

  Future<Map<String, dynamic>> logout() async {
    UserPreferences().removeUser();
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
    return {
      'status': true, 
      'message': "Logout Success!"
    };
  }
}