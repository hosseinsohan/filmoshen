//import 'package:filimo/src/ui/page/music/my_music.dart';
import 'package:filimo/src/resources/database/database_client.dart';
import 'package:filimo/src/ui/page/music_category.dart';
import 'package:filimo/src/ui/page/music_home.dart';
import 'package:filimo/src/ui/page/songs.dart';
import 'package:filimo/src/ui/widget/music/list.dart';
import 'package:filimo/src/ui/widget/myFilm/film_gallery.dart';
import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget {
  final String apiToken;

  MusicScreen({this.apiToken, Key key}) : super(key: key);
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  DatabaseClient db;
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
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
                  Container(
                    height: 56,
                    child: Center(
                      child: Text(
                        'ویترین‌موزیک',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  /*Container(
                      height: 56,
                      child: Center(
                        child: Text(
                            'دسته بندی',
                            style: TextStyle(fontSize: 13),
                          ),
                      ),
                    ),*/
                  Container(
                    height: 56,
                    child: Center(
                      child: Text(
                        'دانلودشده ها',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  /*Container(
                    height: 56,
                    child: Center(
                      child: Text(
                        'موزیک‌های‌من',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              MusicHomeScreen(
                apiToken: widget.apiToken,
              ),
              //MusicCategoryScreen(),
              ListPage()
              //Songs(db)
              /*GalleryFilm(
                text: "میتونی آهنگ هایی که تو گوشیت ذخیره است رو اینجا پخش کنی",
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
