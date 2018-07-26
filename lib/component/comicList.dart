// import 'package:flutter/material.dart';

// class ComicList extends StatefulWidget {
//   @override
//   comicListState createState() {
//     return new comicListState();
//   }
// }

// class ComicListState extends State<ComicList> {
//   final _scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: new NotificationListener(
//         onNotification: _onNotification,
//         child: new RefreshIndicator(
//           // key: _refreshIndicatorKey,
//           onRefresh: _refreshData,
//           child: new ListView.builder(
//             controller: _scrollController,
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemCount: this.list.length + 1,
//             itemBuilder: (_, int index) => _createItem(context, index),
//           ),
//         ),
//       ),
//     );
//   }

//   bool _onNotification(ScrollNotification notification) {
//     if (notification is ScrollUpdateNotification) {
//       // print('onNotification');
//       // print('max:${_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent}  offset:${_scrollController.offset}');
//       // 当滑动到底部的时候，maxScrollExtent和offset会相等
//       // when scroll to the bottom, maxScrollExtent will equal to offset
//       if (_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent >
//               _scrollController.offset &&
//           _scrollController.mostRecentlyUpdatedPosition.maxScrollExtent -
//                   _scrollController.offset <=
//               50) {
//         // 要加载更多
//         if (this.isMore && this.loadMoreStatus != LoadMoreStatus.loading) {
//           // 有下一页 if have more data and not loading
//           print('load more');
//           this.loadMoreStatus = LoadMoreStatus.loading;
//           _loadMoreData();
//           setState(() {});
//         } else {}
//       }
//     }

//     return true;
//   }

//   _refreshData(){}
// }
