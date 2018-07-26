import 'package:flutter/material.dart';
import 'package:flutter_dmzj/util/api.dart' as api;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController;
  TextEditingController _passwdController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    _passwdController = TextEditingController();
  }

  @override
  dispose() {
    _usernameController.dispose();
    _passwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _passwdController,
    );
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          Icon(
            Icons.account_circle,
            color: Colors.deepPurpleAccent,
            size: 100.0,
          ),
          SizedBox(height: 100.0),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: TextField(
              autofocus: true,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '用户名',
              ),
              controller: _usernameController,
            ),
          ),
          TextField(
            controller: _passwdController,
          ),
          RaisedButton(
            elevation: 4.0,
            onPressed: () async {
              var res = api.login();
              if (res != null) {
                Navigator.pop(context, res);
              }
            },
          )
        ],
      ),
    );
  }
}
