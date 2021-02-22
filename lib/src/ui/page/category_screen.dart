import 'package:filimo/src/blocs/categoryList/bloc.dart';
import 'package:filimo/src/models/categoryList/CategoryList.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/page/show_all_film.dart';
import 'package:filimo/src/utils/data.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  String token;
  CategoryScreen({Key key, this.token}) : super(key: key);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => new CategoryListBloc(genresRepository: genresRepository)
        ..add(GetCategoryListEvent()),
      child: BlocBuilder<CategoryListBloc, CategoryListState>(
        builder: (context, state) {
          /*if (state is InitialCategoryState) {
            _update(context);
            return _loadingWidget();
          } else */
          if (state is ErrorCategoryListState) {
            return _errorWidget();
          } else if (state is LoadedCategoryListState) {
            return showData(state.categories);
          } else if (state is LoadingCategoryListState) {
            _loadingWidget(context);
          }
          return _loadingWidget(context);
        },
      ),
    );
  }

  Widget _loadingWidget(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _errorWidget() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(30),
      child: IconButton(
        icon: Icon(
          Icons.refresh,
          size: 50,
        ),
        onPressed: () {
          //_update(context);
        },
      ),
    ));
  }

  Widget showData(CategoryList categoryList) {
    return Scaffold(
      body: ListView.builder(
        itemCount: categoryList.categories.length,
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemBuilder: (_, int index) => InkWell(
            child: Stack(
              children: <Widget>[
                Image.network(
                  '$baseUrl${categoryList.categories[index].url}'??'',
                  height: 120,
                  fit: BoxFit.cover,
                  alignment: index == 17 || index == 18
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                ),
                Container(
                    height: 120,
                    padding: EdgeInsets.only(right: 10),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          categoryList.categories[index].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        )))
              ],
            ),
            onTap: () => categoryList.categories[index].slug != ""
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowAllFilm(
                        categoryTitle: categoryList.categories[index].title,
                        slug: categoryList.categories[index].slug,
                        index: 1,
                        apiToken: widget.token,
                      ),
                    ),
                  )
                : print("")),
      ),
    );
  }
}

class CategotyItem {
  int id;
  String pic;
  String name;
  CategotyItem({this.id, this.name, this.pic});
}
