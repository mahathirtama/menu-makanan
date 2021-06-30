import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan1/modal/api.dart';
import 'package:percobaan1/views/home.dart';
import 'package:percobaan1/views/product.dart';
import 'package:percobaan1/views/profile.dart';
import 'package:percobaan1/views/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, sigIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = true;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(Uri.parse(BaseUrl.login), body: {
      "username": username,
      "password": password,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String namaAPI = data['nama'];
    String emailAPI = data['email'];
    String tglLahirAPI = data['tglLahir'];
    String id = data['id'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.sigIn;
        savePref(value, namaAPI, emailAPI, tglLahirAPI, id);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(
      int value, String nama, String email, String tglLahir, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("email", email);
      preferences.setString("tglLahir", tglLahir);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.sigIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
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
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(title: Text("Login", textAlign: TextAlign.center)),
          body: Form(
            autovalidate: _autovalidate,
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Isikan Username Anda";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(labelText: "Username"),
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
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  color: Colors.orange,
                  child: Text("Login"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text("Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.sigIn:
        return MainMenu(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String nama, email, tgllahir, username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _validate = true;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  save() async {
    final response = await http.post(Uri.parse(BaseUrl.register), body: {
      "nama": nama,
      "email": email,
      "tglLahir": tgllahir,
      "username": username,
      "password": password,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register", textAlign: TextAlign.center)),
      body: Form(
        autovalidate: _validate,
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Nama Lengkap Tidak Boleh kosong";
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Email Tidak Boleh Kosong";
                }
              },
              onSaved: (e) => email = e,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Tgl Lagir Tidak Boleh Kosong";
                }
              },
              onSaved: (e) => tgllahir = e,
              decoration: InputDecoration(labelText: "Tgl Lahir"),
            ),
            TextFormField(
              validator: (e) {
                if (e.length < 8) {
                  return "Harus Lebih Dari 8 Karakter";
                } else {
                  return null;
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
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
              color: Colors.orange,
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}

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

  String nama = "";
  TabController tabController;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Menu Makanan", textAlign: TextAlign.center),
          actions: <Widget>[
            Text("$nama"),
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            ),
          ],
          bottom: TabBar(tabs: <Widget>[
            InkWell(
              child: FittedBox(
                child: Row(
                  children: <Widget>[Icon(Icons.home), Text("Home")],
                ),
              ),
            ),
            InkWell(
              child: FittedBox(
                child: Row(
                  children: <Widget>[Icon(Icons.home), Text("Product")],
                ),
              ),
            ),
            InkWell(
              child: FittedBox(
                child: Row(
                  children: <Widget>[Icon(Icons.home), Text("Profile")],
                ),
              ),
            ),
            // InkWell(
            //   child: FittedBox(
            //     child: Row(
            //       children: <Widget>[Icon(Icons.home), Text("Profile")],
            //     ),
            //   ),
            // ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Product(),
            users(),
            // Profile(null),
          ],
        ),
        bottomNavigationBar: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(style: BorderStyle.none)),
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: ("Home"),
              ),
              Tab(
                icon: Icon(Icons.apps),
                text: ("Product"),
              ),
              Tab(
                icon: Icon(Icons.group),
                text: ("Profile"),
              ),
              // Tab(
              //   icon: Icon(Icons.account_circle),
              //   text: ("Profile"),
              // ),
            ]),
      ),
    );
  }
}
