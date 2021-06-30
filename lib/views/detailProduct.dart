import 'package:flutter/material.dart';
import 'package:percobaan1/modal/menuModel.dart';

class DetailProduct extends StatefulWidget {
  final MenuModel model;
  DetailProduct(this.model);
  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                  tag: widget.model.id,
                  child: Image.network(
                    "http://192.168.1.6/uasmobAPI/upload/" + widget.model.image,
                    fit: BoxFit.cover,
                  )),
            ),
          )
        ];
      },
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 30.0,
              right: 10.0,
              left: 10.0,
              child: Column(
                children: <Widget>[
                  Text("Nama  : " + widget.model.namaItem),
                  Text("Tipe  : " + widget.model.tipe),
                  Text("Harga : " + widget.model.harga),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 8.0,
              right: 8.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Material(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
