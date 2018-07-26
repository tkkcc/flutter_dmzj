import 'package:flutter/material.dart';
import 'package:flutter_dmzj/util/api.dart' as api;
import 'package:flutter_dmzj/component/comicDetail.dart';

class ComicItem extends StatelessWidget {
  ComicItem(this.comic);
  final Map comic;
  // ComicItem(Map e, {key: Key}) {
  //   if (!e.containsKey('id')) {
  //     e['id'] = e['obj_id'];
  //     e['authors'] = e['sub_title'];
  //   }
  //   if (!e.containsKey('tag')) {
  //     var rng = Random();
  //     e['tag'] = e['id'].toString() + rng.nextInt(100).toString();
  //   }
  //   this.comic = ComicStore.fromMap(e);
  //   this.comic.tag = e['tag'];
  // }

  // ComicItem.Entry(this.comic, {key: Key}) {
  //   if (comic.tag.isEmpty) {
  //     var rng = Random();
  //     this.comic.tag = comic.id.toString() + rng.nextInt(100).toString();
  //   }
  // }

  // ComicStore comic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ComicDetailPage(comic: comic,)),
        );
        // ComicDetailPage.intentTo(context, comic);
      },
      child: Column(
        children: <Widget>[
          // Padding(padding: const EdgeInsets.symmetric(vertical: 7.0)),
          Card(
            elevation: 4.0,
            child: Hero(
              // child: CachedNetworkImage(
              //   imageUrl: comic['cover'],
              //   width: 100.0,
              //   height: 150.0,
              //   fit: BoxFit.cover,
              //   httpHeaders: api.header,
              // ),
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
          // Padding(padding: const EdgeInsets.symmetric(vertical: 7.0)),
          Text(
            comic['title'],
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.body2,
          ),
          Text(
            comic['authors'],
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}
