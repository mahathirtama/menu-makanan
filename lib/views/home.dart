import 'package:flutter/material.dart';
import 'package:percobaan1/modal/api.dart';
import 'package:percobaan1/modal/menuModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:percobaan1/views/detailProduct.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final x = list[i];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailProduct(x)));
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: x.id,
                          child: Image.network(
                            "http://192.168.1.6/uasmobAPI/upload/" + x.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        x.namaItem,
                        textAlign: TextAlign.center,
                      ),
                      Text("Rp. " + money.format(int.parse(x.harga)),
                          style: TextStyle(color: Colors.orange)),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ));
  }
}
