import 'package:flutter/material.dart';
import 'package:flutter_dmzj/util/api.dart' as api;

class ComicDetailPage extends StatefulWidget {
  final Map comic;
  ComicDetailPage({Key key, @required this.comic}) : super(key: key);

  @override
  _ComicDetailPageState createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends State<ComicDetailPage> {
  Map comic;
  double screenWidth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comic = widget.comic;
    comic['hit_num'] = comic['hit_num'] ?? '0';
    comic['hot_num'] = comic['hot_num'] ?? '0';
    comic['description'] = comic['description'] ?? '';
    comic['last_updatetime'] = comic['last_updatetime'] ?? '0';
    comic['types'] = comic['types'] ?? '欢乐向';
    // comic['status'] = '';
    comic['chapters'] = comic['chapters'] ?? [];
    load();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(comic['title']),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 4.0,
                child: Hero(
                  tag: comic['id'],
                  // key: Key(comic.id.toString()),
                  // tag: comic.tag,
                  child: Image.network(
                    comic['cover'],
                    width: 100.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                    headers: api.header,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comic['authors'],
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,

                      // style: Theme.of(context).textTheme.caption,
                    ),
                    Text(comic['types']),
                    Text('人气 ${comic['hit_num']}'),
                    Text('订阅 ${comic['hot_num']}'),
                    Text(comic['last_updatetime'] + ' ' + comic['status']),
                    SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.lightBlue,
                          elevation: 4.0,
                          child: Text(
                            '订阅漫画',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            api.subscribe(id: comic['id'].toString());
                          },
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        RaisedButton(
                          color: Colors.lightBlueAccent,
                          elevation: 4.0,
                          child: Text(
                            '继续阅读',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            api.subscribe(id: comic['id'].toString());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Text(comic['description']),
          Divider(),
          chapter()
          // Text(comic['chapters'])
        ],
      ),
    );
  }

  load() async {
    var result = await api.comic(id: comic['id'].toString());
    print(result);
    setState(() {
      comic['authors'] = result['authors'].map((i) => i['tag_name']).join(' ');
      comic['types'] = result['types'].map((i) => i['tag_name']).join(' ');
      // comic['status'] = result['status']['tag_name'];
      comic['last_updatetime'] = formatDate(result['last_updatetime']);
      comic['description'] = result['description'];
      comic['chapters'] = result['chapters'];
      comic['hit_num'] = result['hit_num'];
      comic['hot_num'] = result['hot_num'];
    });
  }

  String formatDate(int long) {
    if (long == null) return '';
    var now = new DateTime.fromMillisecondsSinceEpoch(long * 1000);
    return now.year.toString() +
        '-' +
        now.month.toString().padLeft(2, '0') +
        '-' +
        now.day.toString().padLeft(2, '0');
  }

  Widget chapter() {
    const numEachRow = 4;
    var c = comic['chapters'];
    var r = <Widget>[];
    print('-------------------');
    for (var i in c) {
      var b = <Widget>[];
      r.add(Text(i['title']));
      r.add(SizedBox(
        height: 8.0,
      ));
      for (var j in i['data']) {
        b.add(Container(
          // color: Colors.pink,
          child: SizedBox(
            width: screenWidth * 0.8 / numEachRow,
            child: OutlineButton(
              child: Text(
                j['chapter_title'],
                overflow: TextOverflow.ellipsis,
                // style: TextStyle(),
              ),
              onPressed: () {
                // TODO:
              },
            ),
          ),
        ));
      }
      var d = <Widget>[];
      for (int k = 0; k < b.length; ++k) {
        if (d.isNotEmpty && k % numEachRow == 0) {
          r.add(chapterRow(d));
          d = <Widget>[];
        }
        d.add(b[k]);
      }
      for (int k = 0; k < numEachRow - d.length + 1; ++k) {
        d.add(SizedBox(
          width: screenWidth * 0.8 / numEachRow,
        ));
      }
      r.add(chapterRow(d));
      // for (int k = 0; k < b.length / numEachRow + 1; ++k) {
      //   var d = <Widget>[];
      //   for (int i = 0; i < numEachRow; ++i) {
      //     d.add(b[k * numEachRow + i]);
      //   }
      //   r.add(Row(
      //     children: d,
      //   ));
      // }
    }
    return Column(
      children: r,
    );
  }

  Widget chapterRow(d) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
        children: d,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}
