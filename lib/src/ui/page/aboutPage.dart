import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("درباره ما"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder<String>(
              future: genresRepository
                  .fetchAbout(), // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  return Html(
                    data: snapshot.data,
                    /*useRichText: true,
                      customTextAlign: (_) => TextAlign.right*/
                  );
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.red,
                        size: 60,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                } else {
                  children = <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 20,
                      height: 20,
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
