import 'dart:io';

import 'package:filimo/src/models/CategoryListDetails/CategoryListDetails.dart';
import 'package:filimo/src/models/SubscribeList/SubscribeListModel.dart';
import 'package:filimo/src/models/bookMark/ShowBookMark.dart';
import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/models/categoryList/CategoryList.dart';
import 'package:filimo/src/models/genres/Genres.dart';
import 'package:filimo/src/models/movieDetails/Comment.dart';
import 'package:filimo/src/models/movieDetails/MovieDetails.dart';
import 'package:filimo/src/models/movieDetails/movieLink/MovieLink.dart';
import 'package:filimo/src/models/sendLikeModel/SendLikeModel.dart';
import 'package:filimo/src/models/sendMovieLike/SendMoveiLike.dart';
import 'package:filimo/src/models/slider/SliderModel.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:flutter/cupertino.dart';

class GenresRepository {
  GenresApi genresApi;

  GenresRepository({
    @required this.genresApi,
  }) : assert(genresApi != null);

  Future<List<Genres>> fetchGenresList() async {
    return await genresApi.fetchGenres();
  }

  Future<List<Category>> fetchHomeCategory(int page) async {
    return await genresApi.fetchHomeCategory(page);
  }

  Future<MovieDetails> fetchMovieDetails(String token, String apiToken) async {
    return await genresApi.fetchMovieDetails(token,);
  }

  Future<List<Movie>> fetchShowAllMovies(String slug) async {
    return await genresApi.fetchShowAllMovies(slug);
  }

  Future<CategoryList> fetchCategoryList() async {
    return await genresApi.fetchCategoryList();
  }

  Future<CategoryListDetails> fetchCategoryListDetails(String slug) async {
    return await genresApi.fetchCategoryListDetails(slug);
  }

  Future<SendLikeModel> sendLike(
      String apiToken, int commentId, String type) async {
    return await genresApi.sendLike(apiToken, commentId, type);
  }

  Future<bool> addBookmark(String apiToken, String movieToken) async {
    return await genresApi.addBookmark(apiToken, movieToken);
  }

  Future<bool> removeBookmark(String apiToken, String movieToken) async {
    return await genresApi.removeBookmark(apiToken, movieToken);
  }

  Future<ShowBookMark> showBookmark(String apiToken) async {
    return await genresApi.showBookmark(apiToken);
  }

  Future<SubscribeListModel> showSubscribeList() async {
    return await genresApi.showSubscribeList();
  }

  Future<bool> sendComment(
      String apiToken, String movieType, int movieId, String comment) async {
    return await genresApi.sendComment(apiToken, movieType, movieId, comment);
  }

  Future<SendMoveiLike> sendMovieLike(
      String apiToken, String token, String type) async {
    return await genresApi.sendMovieLike(apiToken, token, type);
  }

  Future<List<Comment>> fetchAllComments(
      String apiToken, String dataToken, String type) async {
    return genresApi.fetchAllComments(apiToken, dataToken, type);
  }

  Future<MovieLink> fetchMovieLink(String link) async {
    return await genresApi.fetchMovieLink(link);
  }

  Future<File> downloadFile(String url, String filename) async {
    return await genresApi.downloadFile(url, filename);
  }

  Future<List<Movie>> fetchSearchResult(String text) async {
    return await genresApi.fetchSearchResult(text);
  }

  Future<SliderModel> fetchSlider() async {
    return await genresApi.fetchSlider();
  }

  Future<String> getIMDBRating(String imdbId, String omdbApiKey) async {
    return await genresApi.getIMDBRating(imdbId, omdbApiKey);
  }

  Future<String> fetchAbout() async {
    return await genresApi.fetchAbout();
  }

  Future<bool> sendViewed(
    String apiToken,
    String token,
  ) async {
    return await genresApi.sendViewed(apiToken, token);
  }

  Future<List<Movie>> fethViewedMovie(String apiToken) async {
    return await genresApi.fethViewedMovie(apiToken);
  }
}
