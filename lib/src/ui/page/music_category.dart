/*import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:filimo/src/utils/data.dart';
import 'package:flutter/material.dart';

class MusicCategoryScreen extends StatefulWidget {
  MusicCategoryScreen({Key key}) : super(key: key);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<MusicCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: categories.length,
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemBuilder: (_, int index) => new StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) =>
                      new Container(
                          color: Colors.green,
                          child: new Center(
                            child: new CircleAvatar(
                              backgroundColor: Colors.white,
                              child: new Text('$index'),
                            ),
                          )),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )));
  }
}
*/