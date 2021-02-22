import 'package:filimo/src/ui/page/show_all_film.dart';
import 'package:filimo/src/ui/page/show_all_music.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  String apiToken;
  String type;
  CustomSearchDelegate({this.apiToken, this.type});
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () {
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return type == "music"
        ? ShowAllMusic(
            type: 'search',
            slug: query,
            apiToken: apiToken,
          )
        : ShowAllFilm(
            apiToken: apiToken,
            index: 5,
            slug: query,
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }

  @override
  String get searchFieldLabel =>
      type == "music" ? "جستجوی موزیک" : "جستجوی فیلم";
}
