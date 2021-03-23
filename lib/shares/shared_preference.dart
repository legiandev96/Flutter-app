import 'package:flutter_application/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.id);
    prefs.setString("tokenType", user.tokenType);
    prefs.setInt("expiresIn", user.expiresIn);
    prefs.setString("token", user.token);
    return true;
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId");
    String tokenType = prefs.getString("tokenType");
    int expiresIn = prefs.getInt("expiresIn");
    String token = prefs.getString("token");

    return User(
      id: userId,
      tokenType: tokenType,
      expiresIn: expiresIn,
      token: token
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userId");
    prefs.remove("tokenType");
    prefs.remove("expiresIn");
    prefs.remove("token");
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}