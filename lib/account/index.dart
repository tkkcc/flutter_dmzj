import 'package:flutter/material.dart';
import 'package:flutter_dmzj/account/login.dart';
import 'package:flutter_dmzj/util/api.dart' as api;

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> {
  Map info;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = api.loginState();
    // if (!api.isLogin()){
    //   Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginPage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return LoginPage();
    // return Center(child:Text('dd'));
    // if (info == null) return LoginPage();
    // return Column(
    //   children: <Widget>[
    //     Expanded(
    //       child: GridView.count(
    //         primary: false,
    //         padding: const EdgeInsets.all(20.0),
    //         crossAxisSpacing: 10.0,
    //         crossAxisCount: 2,
    //         children: <Widget>[
    //           const Text('He\'d have you all unravel at the'),
    //           const Text('Heed not the rabble'),
    //           const Text('Sound of screams but the'),
    //           const Text('Who scream'),
    //           const Text('Revolution is coming...'),
    //           const Text('Revolution, they...'),
    //         ],
    //       ),
    //     )
    //   ],
    // );
  }
}
