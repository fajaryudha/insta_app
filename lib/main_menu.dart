
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
 final VoidCallback signOut;
 MainMenu(this.signOut);
 @override
 _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
 signOut() {
   setState(() {
     widget.signOut();
   });
 }

//  String email = "", nama = "";
//  TabController tabController;

 getPref() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
//      email = preferences.getString("email");
//      nama = preferences.getString("nama");
   });
 }

 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   getPref();
 }

 @override
 Widget build(BuildContext context) {
   return DefaultTabController(
     length: 4,
     child: Scaffold(
       appBar: AppBar(
         title: Text("Halaman Dashboard"),
         actions: <Widget>[
           IconButton(
             onPressed: () {
               signOut();
             },
             icon: Icon(Icons.lock_open),
           )
         ],
        
       ),
       body: Center(
         child: Text(
           "Dashboard"
         ),
       )
     ),
   );
 }
}
