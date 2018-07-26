import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dmzj/util/api.dart' as api;
import 'package:flutter_dmzj/component/comicDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  List _items = [];
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    initLoad();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: _items.isNotEmpty
            ? ListView(children: buildList())
            : Center(
                child: CircularProgressIndicator(),
              ),
        onRefresh: load);
  }

  List<Widget> buildList() {
    return [
      SizedBox(
        height: 190.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: TabBarView(
                  controller: _tabController,
                  children: (_items[0]['data'] as List).map((item) {
                    return Container(
                      // key: ObjectKey(item['obj_id']),
                      child: Image.network(
                        item['cover'],
                        fit: BoxFit.fitWidth,
                        headers: api.header,
                      ),
                    );
                  }).toList()),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 10.0,
              child: Container(
                color: const Color(0x33000000),
                child: TabPageSelector(controller: _tabController),
              ),
            ),
          ],
        ),
      ),
    ]..addAll(_items.sublist(1).map((e) {
        return buildRecommendItem(e);
      }).toList());
    // ..add(
    //   buildGrayLine,
    // );
  }

  Container get buildGrayLine {
    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.only(top: 10.0),
    );
  }

  Widget buildRecommendItem(Map bean) {
    var list = <Widget>[];
    list.addAll([
      buildGrayLine,
      Row(
        children: <Widget>[
          Padding(
            child: Icon(
              Icons.subscriptions,
              size: 18.0,
            ),
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          ),
          Expanded(
            child: Text(
            bean['title'],
            style: Theme.of(context).textTheme.title.copyWith(
              fontSize: 18.0
            ),
          )),
          Icon(Icons.chevron_right)
        ],
      )
    ]);
    var dataS = bean['data'];
    if (dataS.length % 3 == 0) {
      for (var i = 0; i <= (dataS.length - 1) ~/ 3; i++) {
        list.add(Row(
            mainAxisSize: MainAxisSize.min,
            children:
                _getItems(dataS.sublist(i * 3, i * 3 + 3), bean['sort'])));
      }
    } else if (dataS.length % 2 == 0) {
      for (var i = 0; i <= (dataS.length - 1) ~/ 2; i++) {
        list.add(Row(
            mainAxisSize: MainAxisSize.min,
            children:
                _getItems(dataS.sublist(i * 2, i * 2 + 2), bean['sort'])));
      }
    }
    return Column(children: list);
  }

  _getItems(List list, int sort) {
    double height = 110.0;
    if (list.length == 3) height = 150.0;

    return list.map((comic) {
      if (!comic.containsKey('id')) {
        comic['id'] = comic['obj_id'];
      }
      if (!comic.containsKey('authors')) {
        // comic['id'] = comic['obj_id'];
        comic['authors'] = comic['sub_title'];
      }
      // if (!e.containsKey('tag')) {
      // var rng = Random();
      // e['tag'] = e['id'].toString() + rng.nextInt(100).toString();
      // }
      // var comic = ComicStore.fromMap(e);
      // comic.tag = e['tag'];
      var columnList = <Widget>[
        Container(
          height: height,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            child: GestureDetector(
              child: Hero(
                  key: Key(comic['id'].toString()),
                  tag: comic['id'],
                  child: Image.network(
                    comic['cover'],
                    headers: api.header,
                  )),
              onTap: () {
                if (list.length != 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ComicDetailPage(comic: comic)));
                }
              },
            ),
          ),
        ),
        Text(

          comic['title'],
                    overflow: TextOverflow.ellipsis,

          maxLines: 1,
        ),
      ];
      if (list.length != 2)
        columnList.add(Align(
          child: Text(
            comic['authors'],
            style: Theme.of(context).textTheme.caption,
            maxLines: 1,
          ),
        ));
      columnList.add(Padding(padding: EdgeInsets.only(top: 5.0)));
      return Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: columnList,
            ),
          ));
    }).toList();
  }

  Future<Null> load() async {
    // print('load');
    // return;
    var r = await api.recommend();
    setState(() {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("RECOMMEND_JSON", json.encode(r));
      });
      _items = r;
      // _tabController = TabController(length: _items[0]['data'].length, vsync: this);
    });
  }

  void initLoad() async {
    SharedPreferences.getInstance().then((prefs) {
      var j = prefs.getString("RECOMMEND_JSON");
      if (j != null && j.isNotEmpty)
        setState(() {
          _items = json.decode(j);
        });
      else {
        load();
      }
    });
  }
}
