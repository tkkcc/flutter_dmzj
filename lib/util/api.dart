import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:io';
// import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart';

// const utf8 = UTF8;
// const json = JSON;
const channel = 'Android';
const version = '2.7.009';
const api1 = 'http://interface.dmzj.com';
const api3 = 'https://v3api.dmzj.com';
// const api3 = 'https://interface.dmzj.com';
const api_img = 'https://images.dmzj.com';
// var token = '19bb7e14199b7e3d0c7bae3c18acd77f';
// var cookie =
//     'ci_session=DliFioA7nDpLm5RpaKthiXdg5zBF7SPaPHVggnGvr97%2FNdxw7frWWFNTegD0buGCP36r925lefdK%2BOajcdonHLk7W6hetBVkbiv2lpFctJ4N2h67AHuaH6w73GcLb3KR8G%2B8CNvIlzJua7L0EvnGtHgiSzMCG8mXDhgVQwhz3gInYEr8DJoDoXgDYULYWD9j7mMhJPzevkx7s9%2FqB0vdoS9%2Bj6PA4MKLhoZLfYq4iSxx2yTc452jeb3qPHCKS8jJ3%2Fpv5l1P54KzW5btOqjZgY7O9idjJVPRAenzZPGApuYMVdAXyB1I%2BCn1yGZcolqJgGuHS7VydkvZ3kiFCqsU%2FQ%3D%3D; expires=Mon, 23-Jul-2018 03:26:02 GMT; Max-Age=7200; path=/,my=104179618%7Cbilabila%7C%7C919232a1f0e7645860eec595cba3d269; expires=Wed, 22-Aug-2018 01:26:02 GMT; Max-Age=2592000; path=/; domain=.dmzj.com,love=a97619760afdd97c0a9473ce4604ef07; expires=Wed, 22-Aug-2018 01:26:02 GMT; Max-Age=2592000; path=/; domain=.dmzj.com';
// var uid = '104179618';
String token;
String uid;
String username;
String photo;
const header = {"Referer": "http://images.dmzj.com/"};
// const header = {"Referer": "http://www.dmzj.com/"};
Map<String, String> loginState() {
  SharedPreferences.getInstance().then((prefs) {
    uid = prefs.getString('uid');
    token = prefs.getString('token');
    username = prefs.getString('username');
    photo = prefs.getString('photo');
  });
  if (token == null) return null;

  return {
    'photo': photo,
    'username': username,
  };
}

Future chapter({String comicId, String chapterId}) async {
  var res = await http.get(
      '$api3/chapter/$comicId/$chapterId.json?channel=$channel&version=$version');
  if (res.statusCode == 200) return json.decode(res.body);

  return null;
}

Future comic({String id}) async {
  var res =
      await http.get('$api3/comic/$id.json?channel=$channel&version=$version');
  if (res.statusCode == 200) return json.decode(res.body);
  return null;
}

Future recommend() async {
  //  GET https://222.22.29.97/v3/recommend.json?channel=Android&version=2.7.007
  // [{
  //   "category_id": 47,
  //   "data": [
  //       {
  //           "cover": "http://images.dmzj.com/webpic/4/xycpqingyejunsywxsfengmianl.jpg",
  //           "obj_id": 42543,
  //           "status": "连载中",
  //           "sub_title": "作者：椎名うみ",
  //           "title": "想摸青野君",
  //           "type": 1,
  //           "url": ""
  //       },

  var res = await http
      .get('$api3/v3/recommend.json?channel=$channel&version=$version');
  print('finish');
  if (res.statusCode == 200) return json.decode(res.body);
  return null;
}

Future latest({String type, int page = 0}) async {
  //  GET https://222.22.29.95/latest/100/0.json?channel=Android&version=2.7.009
  //  100 1 0 '全部漫画', '原创漫画', '译制漫画'
  var res = await http
      .get('$api3/latest/$type/$page.json?channel=$channel&version=$version');
  if (res.statusCode == 200) return json.decode(res.body);
  return null;
}

Future search({String value, int page = 0}) async {
  // 'https://v2api.dmzj.com/search/show/0/$value/$page.json?channel=$_channel&version=$_version';
//   [
//     {
//         "authors": "シヒラ龙也",
//         "cover": "http://images.dmzj.com/webpic/18/yizhongshaonvq.jpg",
//         "hot_hits": 692117,
//         "id": 14604,
//         "last_name": "第20话修",
//         "status": "已完结",
//         "title": "异种少女Q",
//         "types": "冒险"
//     }
// ]

  var res = await http.get(
      '$api3/search/show/0/$value/$page.json?channel=$channel&version=$version');
  if (res.statusCode == 200) return json.decode(res.body);
  //   print(res.statusCode);
  // print('========================');
  return null;
}

// Future search({String name}) async {
//   var res = await http.get('https://manhua.dmzj.com/tags/search.shtml?s=$name');
//   if (res.statusCode != 200) return null;
//   var dom = parse(res.body);
//   return null;
// }

Future login({String name, String passwd}) async {
  var res = await http.post('https://user.dmzj.com/loginV2/m_confirm',
      body: {'nickname': name, 'passwd': passwd});
  print(res.statusCode);
  if (res.statusCode == 200) {
    var m = json.decode(res.body);
    username = m['data']['nickname'];
    // cookie = res.headers['set-cookie'];
    token = m['data']['dmzj_token'];
    photo = m['data']['photo'];

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('username', username);
      prefs.setString('uid', uid);
      prefs.setString('token', token);
      prefs.setString('photo', photo);
    });
    return {
          'username': username,
          'photo':photo
    };
  }
  return null;
}

Future build() async {
  var res = await http.post('$api3/device/building', body: {
    'uid': uid,
    'user_id': '1',
    'channel_id': '2',
    // 'user_id': '1017865710375010412',
    // 'channel_id': '4045416744317028350',
    'device': 'android'
  });
  print(res.statusCode);
  if (res.statusCode == 200) {
    var m = json.decode(res.body);
    // uid = m['data']['uid'];
    // cookie = res.headers['set-cookie'];
    // token = m['data']['token'];
    // print(res.headers);
    return m;
  }
  return null;
}

Future subscription({
  int subType = 1,
  String letter = 'all',
  int page = 0,
}) async {
  //https://118.194.37.18/api/getReInfo/comic/104179618/0?channel=Android&version=2.7.009
  //https://222.22.29.97/UCenter/subscribe?uid=104179618&sub_type=1&letter=all&token=19bb7e14199b7e3d0c7bae3c18acd77f&page
  var res = await http.get(
    '$api3/UCenter/subscribe?uid=$uid&sub_type=$subType&letter=$letter&token=$token&page=$page'
        '&type=0&channel=$channel&version=$version',
  );
  print(res.body);
  if (res.statusCode == 200) return json.decode(res.body);
  return null;
}

Future author({String id}) async {
  var res = await http
      .get('$api3/UCenter/author/$id.json?channel=$channel&version=$version');
  if (res.statusCode == 200) {
    // print(json.decode(res.body)['nickname']);
    return json.decode(res.body);
  }
  return null;
}

Future unsubscribe({String id, String type = 'mh'}) async {
  //GET https://222.22.29.95/subscribe/cancel?obj_ids=39956&uid=104179618&token=19bb7e14199b7e3d0c7bae3c18acd77f&type=mh&channel=Android&version=2.7.009
  var res = await http.get(
      '$api3/subscribe/cancel?obj_ids=$id&uid=$uid&token=$token&type=$type&channel=$channel&version=$version');
  if (res.statusCode == 200) return json.decode(res.body);
  return null;
}

Future subscribe({String id, String type = 'mh'}) async {
// POST https://222.22.29.95/subscribe/add
// obj_ids:    39956
// uid:        104179618
// token: 19bb7e14199b7e3d0c7bae3c18acd77f
// type:       mh
  var res = await http.post('$api3/subscribe/add',
      body: {'obj_ids': id, 'uid': uid, 'token': token, 'type': type});
  if (res.statusCode == 200) return json.decode(res.body);
  return null;
}

// Future author({int author = 0}) async {
//   var res = await http.get(
//       '$api/UCenter/author/$author.json?channel=$channel&version=$version');
//   if (res.statusCode == 200) return json.decode(res.body);
//   return null;
// }
