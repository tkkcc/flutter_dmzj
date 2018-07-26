import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dmzj/component/comicItem.dart';
import 'package:flutter_dmzj/util/api.dart' as api;

enum View { list, module }

class LatestPage extends StatefulWidget {
  @override
  LatestPageState createState() {
    return LatestPageState();
  }
}

class LatestPageState extends State<LatestPage> {
  var view = View.list;
  var type = '100';
  ScrollController _scrollController;

  List _items = [];
  var page = 0;
  var loading = false;

  @override
  initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels <
              5 &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          !loading) {
        page++;
        load();
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              DropdownButton(
                // iconSize: 29.0,
                value: type,
                isDense: true,
                elevation: 0,
                items: [
                  DropdownMenuItem(
                    value: '100',
                    child: Text(
                      '全部漫画',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '1',
                    child: Text(
                      '原创漫画',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '0',
                    child: Text(
                      '译制漫画',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    page = 0;
                    type = value;
                    load();
                  });
                },
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: view == View.list
                    ? Icon(Icons.view_list)
                    : Icon(Icons.view_module),
                onPressed: () {
                  setState(() {
                    if (view == View.list) {
                      view = View.module;
                    } else {
                      view = View.list;
                    }
                  });
                },
              )
            ],
          ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  sliver: SliverGrid.count(
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 3 : 5,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio:
                        (orientation == Orientation.portrait) ? 0.6 : 0.45,
                    children: _items.map((i) => ComicItem(i)).toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  load() async {
    loading = true;
    var result = await api.latest(type: type, page: page);
    setState(() {
      if (page == 0) {
        _items.clear();
        // _scrollController.animateTo(0.0,
        //     duration: new Duration(seconds: 1), curve: Curves.easeInOut);
      }
      _items.addAll(result);
      loading = false;
    });
    // print(result);
  }
}
