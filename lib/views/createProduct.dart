import 'dart:convert';
import 'dart:math';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:percobaan1/custom/currency.dart';
import 'package:percobaan1/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class CreateProduct extends StatefulWidget {
  final VoidCallback reload;
  CreateProduct(this.reload);
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  String namaItem, tipe, harga, idUsers;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  _pilihGallery() async {
    var image = await ImagePicker().getImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = File(image.path);
    });
  }

  _pilihCamera() async {
    var image = await ImagePicker().getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = File(image.path);
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.product);
      var request = http.MultipartRequest("POST", uri);
      request.fields["namaItem"] = namaItem;
      request.fields["tipe"] = tipe;
      request.fields["harga"] = harga;
      request.fields["idUsers"] = idUsers;
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset("./img/placeholder.png"),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  _pilihGallery();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              onSaved: (e) => namaItem = e,
              decoration: InputDecoration(labelText: "Nama Product"),
            ),
            TextFormField(
              onSaved: (e) => tipe = e,
              decoration: InputDecoration(labelText: "tipe Product"),
            ),
            TextFormField(
              inputFormatters: [],
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "harga Product"),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              color: Colors.orange,
              child: Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
