import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'main_menu.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();
  bool loading = false;
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    loading = true;
    final response = await http.post(
        "https://versilama.oss.go.id/test/instagram_api_codeigniter/index.php/user/user/login",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          "auth": {"user": "aplikasi_1", "password": "test"},
          "user": {"username": email, "password": password}
        }));

    final data = jsonDecode(response.body);

    if (data == '') {
      loading = false;
      _showAlert(data['keterangan'], context);
    }

    if (data['status'] != 200) {
      loading = false;
      _showAlert(data['keterangan'], context);
    } else {
      final user = data['data']['user'];

      String id_user = user['id_user'];
      String username = user['username'];
      String password = data['password'];
      String logged_in = data['logged_in'];
      String status_login = data['status_login'];
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(id_user, username, password, status_login);
      });
      return data;
    }
  }

  savePref(String id_user, String username, String password,
      String status_login) async {
    // log('User $status_login');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("id_user", id_user);
      preferences.setString("username", username);
      preferences.setString("password", password);
      preferences.setString("status_login", status_login);
      preferences.commit();

      loading = false;
    });
  }

  var id_user;
  var status_login;

  getPref() async {
    loading = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id_user = preferences.getString("id_user");
    final response = await http.post(
        "https://versilama.oss.go.id/test/instagram_api_codeigniter/index.php/user/user/check_login",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          "auth": {"user": "aplikasi_1", "password": "test"},
          "user": {"id_user": id_user}
        }));

    var data = jsonDecode(response.body);

    String status_login = data == "" ? "N" : data['status_login'].toString();
    setState(() {
      loading = false;
      _loginStatus =
          status_login == 'Y' ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
    return data;
  }

  signOut() async {
    loading = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString('username');
    // String
    final response = await http.post(
        "https://versilama.oss.go.id/test/instagram_api_codeigniter/index.php/user/user/logout",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          "auth": {"user": "aplikasi_1", "password": "test"},
          "user": {"username": username}
        }));
    final data = jsonDecode(response.body);
    if (data['status'] != 200) {
      loading = false;
      _showAlert(data['keterangan'], context);
    }

    setState(() {
      loading = false;
      preferences.setString("id_user", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loading = false;
    // _loading();
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    // print(_loginStatus);
    return FutureBuilder(
      future: getPref(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          switch (_loginStatus) {
            case LoginStatus.notSignIn:
              return Scaffold(
                appBar: AppBar(
                  title: Text("Insta App"),
                ),
                body: Form(
                  key: _key,
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert email";
                          }
                        },
                        onSaved: (e) => email = e,
                        decoration: InputDecoration(
                          labelText: "email",
                        ),
                      ),
                      TextFormField(
                        obscureText: _secureText,
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          check();
                        },
                        child: Text("Login"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Register()));
                        },
                        child: Text(
                          "Create a new account, in here",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              );
              break;
            case LoginStatus.signIn:
              return MainMenu(signOut);
              break;
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Data'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            ),
          );
        }
      },
    );
  }

  void _showAlert(String data, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text("${data}"),
            ));
  }
}
