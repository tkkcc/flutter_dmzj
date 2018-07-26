// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dmzj/component/comicItem.dart';
import 'package:flutter_dmzj/util/api.dart' as api;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textFieldController;
  ScrollController _scrollController;

  List _items = [];
  var page = 0;
  var loading = false;

  @override
  initState() {
    super.initState();
    _textFieldController = TextEditingController();
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
    _textFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: TextField(
              // TODO:
              style: TextStyle(color: Colors.white),
              controller: _textFieldController,
              autofocus: true,
              // textAlign: TextAlign.start,
              onChanged: (_) {
                page = 0;
                load();
              },
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            sliver: SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio:
                  (orientation == Orientation.portrait) ? 0.66 : 0.45,
              children: _items.map((i) => ComicItem(i)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void load() async {
    var value = _textFieldController.text;
    if (value.isEmpty) return;
    loading = true;
    var result = await api.search(value: value, page: page);
    setState(() {
      if (page == 0) {
        _items.clear();
        _scrollController.animateTo(0.0,
            duration: new Duration(seconds: 1), curve: Curves.easeInOut);
      }
      _items.addAll(result);
      loading = false;
    });
  }
}
