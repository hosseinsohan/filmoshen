import 'package:filimo/src/ui/widget/myFilm/empty_page.dart';
import 'package:flutter/material.dart';

class GalleryFilm extends StatefulWidget {
  final String text;
  GalleryFilm({this.text});
  @override
  _GalleryFilmState createState() => _GalleryFilmState();
}

class _GalleryFilmState extends State<GalleryFilm> {
  @override
  Widget build(BuildContext context) {
    return EmptyPage(pic: "assets/icon/app_icon.png", text: widget.text);
  }
}
