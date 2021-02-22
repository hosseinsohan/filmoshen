import 'package:filimo/src/ui/page/show_all_film.dart';
import 'package:filimo/src/ui/widget/myFilm/film_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFilmScreen extends StatefulWidget {
  final String apiToken;
  MyFilmScreen({this.apiToken, Key key}) : super(key: key);
  @override
  _MyFilmScreenState createState() => _MyFilmScreenState();
}

class _MyFilmScreenState extends State<MyFilmScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            height: kToolbarHeight,
            color: Theme.of(context).primaryColor,
            child: new TabBar(
              indicatorColor: Theme.of(context).textTheme.title.color,
              unselectedLabelColor: Theme.of(context).textTheme.title.color,
              labelColor: Theme.of(context).textTheme.title.color,
              tabs: [
                /*Container(
                  height: 56,
                  child: Center(
                    child: Text(
                      'گالری آفلاین',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),*/
                Container(
                  height: 56,
                  child: Center(
                    child: Text(
                      '‌مشاهده‌شده‌ها',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  child: Center(
                    child: Text(
                      'نشان‌شده‌ها',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            widget.apiToken == null
                ? GalleryFilm(
                    text: "فیلم هایی که قبلا مشاهده کردی رو میتونی اینجا ببینی",
                  )
                : ShowAllFilm(
                    apiToken: widget.apiToken,
                    index: 12,
                  ),
            //GalleryFilm(),
            ShowAllFilm(
              apiToken: widget.apiToken,
              index: 2,
            )
          ],
        ),
      ),
    );
  }
}
