import 'dart:convert';
import 'dart:io';

import 'package:filimo/src/models/CategoryListDetails/CategoryListDetails.dart';
import 'package:filimo/src/models/SubscribeList/SubscribeListModel.dart';
import 'package:filimo/src/models/bookMark/ShowBookMark.dart';
import 'package:filimo/src/models/bookMark/User.dart';
import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/FilmHomeCategories.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/models/categoryList/CategoryList.dart';
import 'package:filimo/src/models/genres/Genres.dart';
import 'package:filimo/src/models/movieDetails/Comment.dart';
import 'package:filimo/src/models/movieDetails/MovieDetails.dart';
import 'package:filimo/src/models/movieDetails/movieLink/MovieLink.dart';
import 'package:filimo/src/models/search/SearchResultModel.dart';
import 'package:filimo/src/models/sendLikeModel/SendLikeModel.dart';
import 'package:filimo/src/models/sendMovieLike/SendMoveiLike.dart';
import 'package:filimo/src/models/slider/SliderModel.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/user_data.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GenresApi {
  final _baseUrl = 'http://moviesapi.ir/api/v1/';
  final _baseUrl1 = '$baseUrl/api/v1/';
  final http.Client httpClient;
  static var httpClient1 = new HttpClient();
  GenresApi({
    @required this.httpClient,
  }) : assert(httpClient != null);

  UserRepository userRepository = UserRepository(
    userApi: UserApi(httpClient: http.Client())
  );
  Future<List<Genres>> fetchGenres() async {
    final url = '$_baseUrl' + 'genres';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
      //
      List<Genres> genresList =
          List<Genres>.from(responseJson.map((i) => Genres.fromJson(i)));

      print(genresList.runtimeType); //returns List<Img>
      print(genresList.runtimeType); //returns Img
      print(genresList[0].name + " 0000000000000000000000000000000");
      return genresList;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Category>> fetchHomeCategory(int page) async {
    final url = '${_baseUrl1}index?page=$page';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
      //
      FilmHomeCategories categoryList =
          FilmHomeCategories.fromJson(responseJson);
      return categoryList.categories;
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<MovieDetails> fetchMovieDetails(String token,) async {
    var apiToken = await getToken();
    final url = apiToken == null
        ? '${_baseUrl1}m/$token'
        : '${_baseUrl1}m/$token?api_token=$apiToken';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return MovieDetails.fromJson(responseJson);
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Movie>> fetchShowAllMovies(String slug) async {
    final url = '${_baseUrl1}tag/$slug';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return (responseJson['movies'] as List)
          .map((i) => Movie.fromJson(i))
          .toList();
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<CategoryList> fetchCategoryList() async {
    final url = '${_baseUrl1}categories';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return CategoryList.fromJson(responseJson);
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<CategoryListDetails> fetchCategoryListDetails(String slug) async {
    final url = '${_baseUrl1}categories/$slug';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return CategoryListDetails.fromJson(responseJson);
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  //send like of comment
  Future<bool> addBookmark(String apiToken, String movieToken) async {
    print("dddddddddddd");
    var url = _baseUrl1 + 'addBookmark/$movieToken?api_token=$apiToken';
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(" اطلاعات ارسال شد لایک");
    print(' add bookMark ${response.body}');
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 1) {
        return true;
      } else
        return false;
    } else {
      return false;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<bool> removeBookmark(String apiToken, String movieToken) async {
    print("dddddddddddd");
    var url = _baseUrl1 + 'removeBookmark/$movieToken?api_token=$apiToken';
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(" اطلاعات ارسال شد لایک");
    print(' remove bookMark ${response.body}');
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 1) {
        return true;
      } else
        return false;
    } else {
      return false;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<ShowBookMark> showBookmark(String apiToken) async {
    print("dddddddddddd");
    var url = _baseUrl1 + 'bookmarked?api_token=$apiToken';
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(" اطلاعات ارسال شد لایک");
    print(' remove bookMark ${response.body}');
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 1) {
        return ShowBookMark.fromJson(json.decode(response.body));
      } else
        return ShowBookMark(
          bookmarks: [],
          status: json.decode(response.body)['status'],
          user: json.decode(response.body)['user'] != null
              ? User.fromJson(json.decode(response.body)['user'])
              : null,
        );
    } else {
      return null;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<SendLikeModel> sendLike(
      String apiToken, int commentId, String type) async {
    print("""
    'api_token': $apiToken,
        'comment_id': $commentId,
        'type': $type,
        """);
    var url = _baseUrl1 + 'sendLike';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        'api_token': apiToken,
        'comment_id': commentId,
        'type': type,
      }),
    );
    print(" اطلاعات ارسال شد لایک");
    print(response.body);
    if (response.statusCode == 200) {
      return SendLikeModel.fromJson(json.decode(response.body));
    } else {
      return null;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<SubscribeListModel> showSubscribeList() async {
    var url = _baseUrl1 + 'subscribe';
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(" اطلاعات ارسال شد لایک");
    print(' remove bookMark ${response.body}');
    if (response.statusCode == 200) {
      return SubscribeListModel.fromJson(json.decode(response.body));
    } else {
      return null;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<bool> sendComment(
      String apiToken, String movieType, int movieId, String comment) async {
    print("""
    'api_token': $apiToken,
        'movie_type': $movieType,
        'commentable_id': $movieId,
        'comment': $comment,
        """);
    var url = _baseUrl1 + 'sendComment';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        'api_token': apiToken,
        'movie_type': movieType,
        'commentable_id': movieId,
        'comment': comment,
      }),
    );
    print(" اطلاعات ارسال شد لایک");
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<SendMoveiLike> sendMovieLike(
      String apiToken, String token, String type) async {
    print("""
    'api_token': $apiToken,
        'token': $token,
        'type': $type,
        """);
    var url = _baseUrl1 + 'movieLike';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        'api_token': apiToken,
        'token': token,
        'type': type,
      }),
    );
    print(" اطلاعات ارسال شد لایک");
    print(response.body);
    if (response.statusCode == 200) {
      return SendMoveiLike.fromJson(json.decode(response.body));
    } else {
      return null;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<List<Comment>> fetchAllComments(
      String apiToken, String dataToken, String type) async {
    var url = _baseUrl1 + 'allComments/$dataToken/$type?api_token=$apiToken';
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(" اطلاعات ارسال شد لایک");
    print(' remove bookMark ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body)['comments'] != null
          ? (json.decode(response.body)['comments'] as List)
              .map((i) => Comment.fromJson(i))
              .toList()
          : null;
    } else {
      return null;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<MovieLink> fetchMovieLink(String link) async {
    final url = 'https://napi.arvancloud.com/vod/2.0/videos/$link';
    print(url);
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Apikey 26c1775d-dd61-4c8a-833f-0c40026fdaf8',
      },
    );
    print("در حال دریافت اطلاعات");
    print(' music:===> ${response.body}');
    if (response.statusCode == 200) {
      try {
        return MovieLink.fromJson(json.decode(response.body));
      } catch (e) {
        throw e;
        //return [];
      }
    } else {
      return null;
    }
  }

  Future<File> downloadFile(String url, String filename) async {
    var request = await httpClient1.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await foundation.consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<List<Movie>> fetchSearchResult(String text) async {
    final url = '${_baseUrl1}search?q=$text';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return SearchResultModel.fromJson(responseJson).res.movies;
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<SliderModel> fetchSlider() async {
    final url = '${_baseUrl1}slider';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return SliderModel.fromJson(responseJson);
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> getIMDBRating(String imdbId, String omdbApiKey) async {
    final url = 'http://www.omdbapi.com/?apikey=$omdbApiKey&i=$imdbId';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return responseJson['imdbRating'];
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> fetchAbout() async {
    final url = '${_baseUrl1}aboutPage';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return responseJson['data'];
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> sendViewed(
    String apiToken,
    String token,
  ) async {
    print("""
    'api_token': $apiToken,
        'token': $token,
        """);
    var url = _baseUrl1 + 'observed';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        'api_token': apiToken,
        'token': token,
      }),
    );
    print(" اطلاعات ارسال شد لایک");
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('خطا در برقراری ارتباط');
    }
  }

  Future<List<Movie>> fethViewedMovie(String apiToken) async {
    print("dddddddddddd");
    var url = _baseUrl1 + 'observed?api_token=$apiToken';
    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return (responseJson['movies'] as List)
          .map((i) => Movie.fromJson(i))
          .toList();
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }
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
