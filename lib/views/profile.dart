import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percobaan1/main.dart';

class Profile extends StatefulWidget {
  final VoidCallback signOut;
  Profile(this.signOut);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            signOut();
          },
          color: Colors.orange,
          child: Text("Logout"),
        ),
      ),
    );
  }
}
