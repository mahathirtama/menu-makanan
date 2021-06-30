import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class users extends StatefulWidget {
  @override
  _usersState createState() => _usersState();
}

class _usersState extends State<users> {
  String nama = "";
  String email = "";
  String tglLahir = "";
  TabController tabController;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      email = preferences.getString("email");
      tglLahir = preferences.getString("tglLahir");
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
    return Scaffold(
      body: Center(
        child: Text("nama : $nama \nEmail : $email \ntglLahir : $tglLahir"),
      ),
    );
  }
}
