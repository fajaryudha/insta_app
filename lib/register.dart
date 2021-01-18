import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_app/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email, password, nama;
  final _key = new GlobalKey<FormState>();

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
      save();
    }
  }

  save() async {
    final response = await http.post(
        "https://versilama.oss.go.id/test/instagram_api_codeigniter/index.php/user/user/registrasi",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          "auth": {"user": "aplikasi_1", "password": "test"},
          "user": {"username": email, "password": password},
          "user_profile": {"nama": nama, "nama_profile": "@" + nama}
        }));

    // final response = await http.post(
    //     "https://versilama.oss.go.id/test/instagram_api_codeigniter/index.php/user/user/registrasi",
    //     body: {"nama": nama, "email": email, "password": password});
    final data = jsonDecode(response.body);

    if (data == '') {
      _showAlert("Kesalahan Sistem", 1, context);
    }
    int status = data['status'];
    // log("data $data");
    String keterangan = data['keterangan'];
    if (status == 200) {
      Timer(Duration(seconds: 3), () {
        _showAlert(keterangan, 0, context);
      });
      setState(() {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      });
    } else {
      _showAlert(keterangan, 1, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert fullname";
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert email";
                }
              },
              onSaved: (e) => email = e,
              decoration: InputDecoration(labelText: "email"),
            ),
            TextFormField(
              obscureText: _secureText,
              onSaved: (e) => password = e,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }

  void _showAlert(String data, int type_error, BuildContext context) {
    String title;
    if (type_error == 0) {
      title = "Berhasil";
    } else {
      title = "Error";
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("${title}"),
              content: Text("${data}"),
            ));
  }
}
