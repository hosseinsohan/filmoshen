import 'dart:convert';

import 'package:filimo/src/utils/url.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  final _baseUrl = '$baseUrl/api/v1/';
  final http.Client httpClient;

  UserApi({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<String> sendNumber(String mobile) async {
    var url = _baseUrl + 'login/sendCode';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
      }),
    );
    print("شماره $mobile ارسال شد ");
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 1) {
        return json.decode(response.body)['loginCode'];
      } else
        return null;
    } else {
      throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<String> sendCode(String mobile, String code) async {
    var url = _baseUrl + 'login/checkCode';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'mobile': mobile, 'loginCode': code}),
    );
    print("شماره $mobile ارسال شد ");
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 1) {
        return json.decode(response.body)['api_token'];
      } else
        return "notValid";
    } else {
      throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<String> startApp(String mobile, String token) async {
    var url = _baseUrl + 'refresh';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{'api_token': token}),
    );

    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 1) {
        await saveToken(mobile, json.decode(response.body)['api_token'],
            json.decode(response.body)['omdb_api_key']);
        print(response.body.toString());
        return json.decode(response.body)['api_token'];
      } else
        return null;
    } else {
      return null;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<bool> deleteToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString("mobile", "");
    prefs.setString("token", "").then((bool success) {
      return success;
    });
    return false;
  }

  Future<bool> saveToken(String mobile, String token, String imdbRating) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString("mobile", mobile);
    prefs.setString("imdbRating", imdbRating);
    prefs.setString("token", token).then((bool success) {
      return success;
    });
    return false;
  }

  Future<GetTokenAndMobile> getToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString("token") ?? "";
    print('token is $token');
    var imdbRating = prefs.getString("imdbRating") ?? "";
    print('imdbRating key is $imdbRating');
    var mobile = prefs.getString("mobile") ?? "";
    if (token == null || token == "") {
      return null;
    }
    return GetTokenAndMobile(mobile, token, imdbRating);
  }

  Future<String> fetchSubscribeDays(String apiToken) async {
    final url = '${_baseUrl}subscribe_days?api_token=$apiToken';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      if (responseJson['status'] == -1) {
        return null;
      } else {
        if (responseJson['status'] == 1) {
          return responseJson['subscribe_days'].toString();
        }
      }

      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw response.body.toString();
      case 401:
      case 403:
        throw response.body.toString();
      case 500:
      default:
        throw 'Error occured while Communication with Server with StatusCode : ${response.statusCode}';
    }
  }
}

class GetTokenAndMobile {
  final String token;
  final String mobile;
  String imdbRating;
  GetTokenAndMobile(this.mobile, this.token, this.imdbRating);
}
