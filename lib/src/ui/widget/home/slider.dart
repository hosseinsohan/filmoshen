/*
import 'package:filimo/src/ui/page/show_all_film.dart';
import 'package:filimo/src/ui/page/video_details.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

 */
/*
class SliderList extends StatefulWidget {
  Categories category;
  SliderList({this.category, Key key}) : super(key: key);
  @override
  _SliderListState createState() => _SliderListState();
}

class _SliderListState extends State<SliderList> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  ];
  @override
  Widget build(BuildContext context) {
    return _loadedWidget();
  }

  Widget _loadedWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "ویژه",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              Row(
                children: <Widget>[
                  Material(
                      child: InkWell(
                          child: Text(
                            "مشاهده همه",
                            style: TextStyle(
                                color: redColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                          /*onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShowAllFilm(
                                    category: widget.category,
                                    index: 0,
                                  ),
                                ),
                              )*/)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: redColor,
                    size: 15,
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          margin: EdgeInsets.only(top: 10.0),
          child: ItemLoad(imgList),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}

class ItemLoad extends StatefulWidget {
  final List<String> imgList;
  ItemLoad(this.imgList);
  @override
  _ItemLoadState createState() => _ItemLoadState();
}

class _ItemLoadState extends State<ItemLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.imgList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: index == 0 ? 10 : 5,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey,
                ),
                child: Container(
                  width: 270,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.imgList[index],
                        width: 150,
                        height: 225,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => DetailPage()));
          },
        );
      },
    );
  }
}
*/
