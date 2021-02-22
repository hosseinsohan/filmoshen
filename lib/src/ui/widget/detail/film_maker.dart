import 'package:filimo/src/models/movieDetails/Actor.dart';
import 'package:filimo/src/models/movieDetails/Factors.dart';
import 'package:filimo/src/models/movieDetails/Writer.dart';
import 'package:flutter/material.dart';

class FilmMaker extends StatefulWidget {
  final List<Actor> actors;
  final Factors factors;
  final String aboutFilm;
  final String story;
  FilmMaker({this.factors, this.actors, this.aboutFilm, this.story});
  @override
  _FilmMakerState createState() => _FilmMakerState();
}

class _FilmMakerState extends State<FilmMaker> {
  bool descTextShowFlag = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.description,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Theme.of(context).textTheme.title.color),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'داستان فیلم',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Theme.of(context).textTheme.title.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.story??"داستان ثبت نشده است!",
                maxLines: descTextShowFlag ? 20 : 2,textAlign: TextAlign.start),
            InkWell(
                onTap: (){ setState(() {
                  descTextShowFlag = !descTextShowFlag;
                }); },
                child:widget.story==null?Container():
                Align(alignment: Alignment.centerLeft, child: descTextShowFlag ? Text("نمایش کمتر",style: TextStyle(color: Colors.blue),) :  Text("نمایش بیشتر",style: TextStyle(color: Colors.blue)))

            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(Icons.description,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Theme.of(context).textTheme.title.color),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'درباره فیلم',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Theme.of(context).textTheme.title.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.aboutFilm??"توضیحاتی ثبت نشده است!",
                maxLines: descTextShowFlag ? 20 : 2,textAlign: TextAlign.start),
            InkWell(
              onTap: (){ setState(() {
                descTextShowFlag = !descTextShowFlag;
              }); },
              child:widget.aboutFilm==null?Container():
                  Align(alignment: Alignment.centerLeft, child: descTextShowFlag ? Text("نمایش کمتر",style: TextStyle(color: Colors.blue),) :  Text("نمایش بیشتر",style: TextStyle(color: Colors.blue)))

            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(Icons.perm_media,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Theme.of(context).textTheme.title.color),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'عوامل سازنده',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Theme.of(context).textTheme.title.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            maker(title: 'بازیگر', actors: widget.actors),
            SizedBox(
              height: 20,
            ),
            Wrap(
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                perFormer(title: 'آهنگساز', makers: widget.factors.composers),
                perFormer(
                  title: 'کارگردان',
                  makers: widget.factors.directors,
                ),
                perFormer(
                  title: 'تهیه کننده',
                  makers: widget.factors.producers,
                ),
                perFormer(
                  title: 'فیلم بردار',
                  makers: widget.factors.photography,
                ),
                perFormer(
                  title: 'نویسنده',
                  makers: widget.factors.writers,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget maker({
    String title,
    List<Actor> actors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300].withOpacity(0.5)
                  : Theme.of(context).textTheme.title.color.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 13),
        ),
        Wrap(
          runAlignment: WrapAlignment.start,
          children: actors
              .map(
                (data) => Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    data.name,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Theme.of(context).textTheme.title.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }

  Widget perFormer({
    String title,
    List<Writer> makers,
  }) {
    return makers.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300].withOpacity(0.5)
                        : Theme.of(context)
                            .textTheme
                            .title
                            .color
                            .withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: makers
                    .map(
                      (data) => Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 10.0,
                        ),
                        child: Text(
                          data.name,
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[300]
                                  : Theme.of(context).textTheme.title.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          );
  }
}
