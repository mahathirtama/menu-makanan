import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percobaan1/modal/api.dart';
import 'package:percobaan1/modal/menuModel.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final MenuModel model;
  final VoidCallback reload;
  EditProduct(this.model, this.reload);
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _key = new GlobalKey<FormState>();
  String namaItem, tipe, harga;

  TextEditingController txtNamaItem, txtTipe, txtHarga;

  setup() {
    txtNamaItem = TextEditingController(text: widget.model.namaItem);
    txtTipe = TextEditingController(text: widget.model.tipe);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(Uri.parse(BaseUrl.editMenu), body: {
      "namaItem": namaItem,
      "tipe": tipe,
      "harga": harga,
      "id": widget.model.id
    });
    final data = jsonDecode(response.body);
    int value = data["value"];
    String pesan = data["message"];

    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data", textAlign: TextAlign.center),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNamaItem,
              onSaved: (e) => namaItem = e,
              decoration: InputDecoration(labelText: "Nama Product"),
            ),
            TextFormField(
              controller: txtTipe,
              onSaved: (e) => tipe = e,
              decoration: InputDecoration(labelText: "tipe Product"),
            ),
            TextFormField(
              controller: txtHarga,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "harga Product"),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              color: Colors.orange,
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
