import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'app_data.dart';
import 'shared_preference_helper.dart';

/// POST Api
Future<http.Response> postRequest(String endpoint, {Map? parameters}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url , params:: $parameters");
  dynamic response;
  try {
    String token = AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken();
    log("TOKEN :: $token ");

    response = await http
        .post(
          Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
          body: parameters ?? "",
        )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

/// GET Api
Future<http.Response> getRequest(String endpoint) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url");
  dynamic response;
  try {
    String token = AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken();
    log("TOKEN $token");
    Map<String, String> params = <String, String>{
      HttpHeaders.authorizationHeader: token,
    };
    log(params.toString());
    response = await http
        .get(
          Uri.parse(url),
          headers: params,
        )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

/// PUT Api
Future<http.Response> putRequest(String endpoint, {Map? parameters}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url");
  dynamic response;
  try {
    String token = AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken();
    response = await http
        .put(
          Uri.parse(url),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          body: parameters != null ? json.encode(parameters) : null,
        )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

/// DELETE Api
Future<http.Response> deleteNewRequestWithToken(String endpoint,
    {Map? parameters}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url");
  dynamic response;
  try {
    String token = AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken();
    response = await http
        .delete(
          Uri.parse(url),
          headers: <String, String>{
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          body: parameters != null ? json.encode(parameters) : null,
        )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

Future<dynamic> postRequestJson(
    String endpoint, String? productId, Map<dynamic, dynamic>? params) async {
  final parameters =
      jsonEncode({"product_id": productId ?? "", "pair": params});
  var headers = {
    'Authorization': AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken()
  };
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url + $parameters");
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields.addAll({'product_id': productId ?? "", 'pair': '$params'});

  request.headers.addAll(headers);
  // dynamic streamedResponse;
  // streamedResponse = await request.send();
  // var response = await http.Response.fromStream(streamedResponse);
  //
  // print(response);
  return await request.send();
}

Future<http.Response> getRequestWithToken(String endpoint,
    {String? token}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url");
  dynamic response;
  debugPrint('Bearer $token');
  try {
    response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

Future<dynamic> multiPartPostWithToken(String endpoint, File? file, String slug,
    {String? token}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url + $file");
  dynamic response;

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers[HttpHeaders.acceptHeader] = "application/json";
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    request.headers[HttpHeaders.contentTypeHeader] = "application/json";
    request.fields['slug'] = slug;
    request.files
        .add(await http.MultipartFile.fromPath('health_report', file!.path));
    var res = await request.send();
    response = await res.stream.bytesToString();
    // print(response.toString());
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

Future<dynamic> multiPartPostWithTokenForImageUpload(
    String endpoint, File? file, String token) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url + $file");
  dynamic response;

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers[HttpHeaders.acceptHeader] = "application/json";
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    request.headers[HttpHeaders.contentTypeHeader] = "application/json";
    request.files
        .add(await http.MultipartFile.fromPath('profile_picture', file!.path));
    var res = await request.send();
    response = await http.Response.fromStream(res);
    // print(response.toString());
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

Future<http.Response> postRequestWithTokenParamsAsList(
    String endpoint, List<Map>? params,
    {String? token}) async {
  final url = AppData.baseUrl + endpoint;
  dynamic response;
  try {
    response = await http
        .post(
          Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          body: params != null ? json.encode(params) : null,
        )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}

//HealthFi Project Integration

Future<http.Response> healthFiPostRequest(String endpoint,
    {Map? parameters}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url + $parameters");
  dynamic response;
  try {
    String token = AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken();
    response = await http
        .post(
          Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: token,
            "x-corp-id": "63a92e169e2d704918450dec",
            "x-corp-secret": "y698FaF5lzmjErQY6QxHn65sBCZLyVtY",
          },
          body: parameters != null ? json.encode(parameters) : null,
        )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}


///Post request for checking duplicate in checkout
Future<http.Response> postRequestWithCustomerId(String endpoint,
    {Map? parameters}) async {
  final url = AppData.baseUrl + endpoint;
  log("URL :: $url + $parameters");
  dynamic response;
  try {
    String token = AppData.accessToken.isNotEmpty
        ? AppData.accessToken
        : await SharedPreferencesHelper.getHeaderToken();
    response = await http
        .post(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token,
        "x-corp-id": "63a92e169e2d704918450dec",
        "x-corp-secret": "y698FaF5lzmjErQY6QxHn65sBCZLyVtY",
      },
      body: parameters != null ? json.encode(parameters) : null,
    )
        .timeout(const Duration(seconds: 60));
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }
  return response;
}
