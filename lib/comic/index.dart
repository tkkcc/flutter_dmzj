import 'package:flutter/material.dart';
import 'package:flutter_dmzj/comic/latest.dart';
import 'package:flutter_dmzj/comic/search.dart';
import 'package:flutter_dmzj/comic/recommend.dart';

class ComicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Text('推荐'),
                Text('更新'),
                Text('分类'),
                Text('排行'),
                Text('专题'),
                // Tab(icon: Icon(Icons.search)),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              )
            ],
          ),
          body: TabBarView(
            children: [
              RecommendPage(),
              LatestPage(),
            ],
          ),
        ),
      ),
    );
  }
}
