import 'package:filimo/src/models/movieDetails/Movie.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/widget/detail/arc_clipper.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Widget getMoviePosterBackground(String url) {
  return Container(
    alignment: Alignment.centerLeft,
    child: Opacity(
      opacity: 0.6,
      child: ArcBannerImage(
        '$baseUrl$url',
        230.0,
      ),
    ),
  );
}

Widget getMoviePosterAndRatingSection(double marginTop, double ratingTop,
    BuildContext context, Movie movie, String apiToken, String imdbApikey) {
  return SafeArea(
    child: Row(
      children: <Widget>[
        getMoviePoster(marginTop, context, movie, apiToken, imdbApikey),
      ],
    ),
  );
}

Widget getMoviePoster(double marginTop, BuildContext context, Movie movie,
    String apiToken, String imdbApikey) {
  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(
          top: marginTop,
          right: 20.0,
        ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.white54,
                blurRadius: 25.0,
                offset: Offset(0.0, 4.0),
                spreadRadius: 5.0,
              ),
            ],
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            )),
        width: 120.0,
        height: 180.0,
        child: Image.network(
          '$baseUrl${movie.cover}',
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(width: 10),
      Container(
        width: MediaQuery.of(context).size.width - 150,
        padding: const EdgeInsets.only(
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              child: Text("",
                  strutStyle: StrutStyle(height: 1.5),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              height: 50,
              child: Text("",
                  strutStyle: StrutStyle(height: 1.5),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ),
            Text(movie.title,
                strutStyle: StrutStyle(height: 1.5),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                movie.imdb_id == null
                    ? Container()
                    : FutureBuilder<String>(
                        future: genresRepository.getIMDBRating(movie.imdb_id,
                            imdbApikey), // a previously-obtained Future<String> or null
                        builder: (_, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IRANYekanMobileMedium'),
                                children: <TextSpan>[
                                  new TextSpan(text: snapshot.data),
                                  new TextSpan(
                                      text: '/',
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey
                                              : Colors.black54)),
                                  new TextSpan(
                                      text: '10',
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey
                                              : Colors.black54)),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 0.5,
                              ),
                              width: 10,
                              height: 10,
                            );
                          }
                        },
                      )
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('${movie.age == null ? "" : movie.age.title}',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Colors.black54)))
          ],
        ),
      ),
    ],
  );
}

Widget getMovieDetailsSection(double marginTop, DateTime time, String url) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      getMoviePosterBackground(url),
    ], // BACK POSTER > DETAILS > LIST VIEW
  );
}
