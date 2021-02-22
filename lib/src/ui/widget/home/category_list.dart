import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/ui/page/show_all_film.dart';
import 'package:filimo/src/ui/page/video_details.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryList extends StatefulWidget {
  final Category category;
  final bool haveShowAll;
  final String apiToken;

  CategoryList({this.category, this.haveShowAll, this.apiToken, Key key})
      : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return _loadedWidget(
        title: widget.category.title, categories: widget.category);
  }

  Widget _loadedWidget({String title, Category categories}) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontWeight:
                        widget.haveShowAll ? FontWeight.w800 : FontWeight.w600,
                    fontSize: widget.haveShowAll ? 17 : 13),
              ),
              widget.haveShowAll
                  ? Row(
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
                                onTap: () => widget.category.slug != ""
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ShowAllFilm(
                                            slug: widget.category.slug,
                                            index: 0,
                                            categoryTitle:
                                                widget.category.title,
                                            apiToken: widget.apiToken,
                                          ),
                                        ),
                                      )
                                    : print(""))),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: redColor,
                          size: 15,
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          margin: EdgeInsets.only(top: 10.0),
          child: ItemLoad(categories.movies, widget.apiToken),
        )
      ],
    );
  }
}

class ItemLoad extends StatefulWidget {
  final List<Movie> movies;
  final String apiToken;

  ItemLoad(this.movies, this.apiToken);

  @override
  _ItemLoadState createState() => _ItemLoadState();
}

class _ItemLoadState extends State<ItemLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.movies.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: index == 0 ? 10 : 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 225,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: '$baseUrl${widget.movies[index].cover}',
                          width: 150,
                          height: 225,
                          fit: BoxFit.cover,
                        )

                        //Image.network(widget.categories.data[index].poster,),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      widget.movies[index].title,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DetailPage(
                        widget.movies[index].token, widget.apiToken)));
          },
        );
      },
    );
  }
}
