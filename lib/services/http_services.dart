import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/shares/shared_preference.dart';

class HttpService {
    createAuthentication() async {
      var token = await UserPreferences().getToken();
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      };
      return headers;
    }

    postMethodNotAuth(String url, dynamic dataRequest) async {
      Map<String, String> headers = {"Content-type": "application/json"};
      Response data = await post(url, headers: headers, body: json.encode(dataRequest));
      int statusCode = data.statusCode;
      if(statusCode != 200) {
        handleErrorServer();
      }
      dynamic dataResponse = json.decode(data.body);
      return dataResponse;
    }

    getMethod(String url) async {
      Map<String, String> headers = await createAuthentication();
      Response data = await get(url, headers: headers);
      int statusCode = data.statusCode;
      if(statusCode != 200) {
        handleErrorServer();
      }
      dynamic dataResponse = json.decode(data.body);
      return dataResponse;
    }

    postMethod(String url, dynamic dataRequest) async {
      Map<String, String> headers = await createAuthentication();
      Response data = await post(url, headers: headers, body: json.encode(dataRequest));
      int statusCode = data.statusCode;
      if(statusCode != 200) {
        handleErrorServer();
      }
      dynamic dataResponse = json.decode(data.body);
      return dataResponse;
    }

    putMethod(String url, String dataRequest) async {
      Map<String, String> headers = await createAuthentication();
      Response data = await put(url, headers: headers, body: dataRequest);
      int statusCode = data.statusCode;
      if(statusCode != 200) {
        handleErrorServer();
      }
      dynamic dataResponse = json.decode(data.body);
      return dataResponse;
    }

    patchMethod(String url, String dataRequest) async {
      Map<String, String> headers = await createAuthentication();
      Response data = await patch(url, headers: headers, body: dataRequest);
      int statusCode = data.statusCode;
      if(statusCode != 200) {
        handleErrorServer();
      }
      dynamic dataResponse = json.decode(data.body);
      return dataResponse;
    }

    deleteMethod(String url, String dataRequest) async {
      Map<String, String> headers = await createAuthentication();
      Response data = await delete(url, headers: headers);
      int statusCode = data.statusCode;
      if(statusCode != 200) {
        handleErrorServer();
      }
      dynamic dataResponse = json.decode(data.body);
      return dataResponse;
    }

    handleErrorServer() {
      Fluttertoast.showToast(
        msg: "Request to server failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
}