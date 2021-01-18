import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'model/posting_profile.dart';

List<Posting_profile> _posting_profile;

class Post extends StatelessWidget {
  const Post({Key key}) : super(key: key);

  Future<Posting_profile> loadDataString() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id_user = preferences.getString("id_user");

    final response = await http.post(
        "https://versilama.oss.go.id/test/instagram_api_codeigniter/index.php/post/post/select",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          "posting": {"id_profile": id_user, "jenis_select": "teman"},
        }));

    final jsonResponse = jsonDecode(response.body);
    // List<Datum> datum = json.decode(jsonResponse['data']);
    // log("$datum");

    return Posting_profile.fromMap(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}
