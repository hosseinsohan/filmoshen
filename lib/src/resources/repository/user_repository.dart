import 'package:filimo/src/resources/api/user_api.dart';
import 'package:flutter/material.dart';

class UserRepository {
  UserApi userApi;

  UserRepository({
    @required this.userApi,
  });

  Future<String> authenticate({
    @required String mobile,
    @required String code,
  }) async {
    String data = await userApi.sendCode(mobile, code);
    return data;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await userApi.deleteToken();
    return;
  }

  Future<void> persistToken(String mobile, String token) async {
    /// write to keystore/keychain
    await userApi.saveToken(mobile, token, "");
    return;
  }

  Future<String> hasToken() async {
    /// read from keystore/keychain
    GetTokenAndMobile tokenAndMobile = await userApi.getToken();
    if (tokenAndMobile == null)
      return null;
    else {
      return await userApi.startApp(
          tokenAndMobile.mobile, tokenAndMobile.token);
    }
  }

  Future<String> getToken() async {
    /// read from keystore/keychain
    GetTokenAndMobile tokenAndMobile = await userApi.getToken();
    if (tokenAndMobile == null)
      return null;
    else {
      return tokenAndMobile.token;
    }
  }

  Future<String> getIMDBApiKey() async {
    /// read from keystore/keychain
    GetTokenAndMobile tokenAndMobile = await userApi.getToken();
    if (tokenAndMobile == null)
      return null;
    else {
      return tokenAndMobile.imdbRating;
    }
  }

  Future<String> fetchSubscribeDays(String apiToken) async {
    return await userApi.fetchSubscribeDays(apiToken);
  }
}
