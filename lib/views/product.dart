import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percobaan1/modal/api.dart';
import 'package:percobaan1/modal/menuModel.dart';
import 'package:percobaan1/views/createProduct.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan1/views/editProduct.dart';
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final money = NumberFormat("#,##0", "en_US");
  var loading = true;
  final list = new List<MenuModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.readMenu));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = MenuModel(
            api["id"],
            api["namaItem"],
            api["tipe"],
            api["harga"],
            api["createdDate"],
            api["idUsers"],
            api["namaUsers"],
            api["image"]);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Apa Kamu Yakin?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deleteMenu), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data["value"];
    String pesan = data['message'];
    if (value == 1) {
      Navigator.pop(context);
      _lihatData();
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateProduct(_lihatData)));
      }),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          "http://192.168.1.6/uasmobAPI/upload/" + x.image,
                          width: 100.0,
                          height: 180.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.namaItem,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(x.tipe),
                              Text(money.format(int.parse(x.harga))),
                              Text(x.namaUsers),
                              Text(x.createdDate),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProduct(x, _lihatData)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _dialogDelete(x.id);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
