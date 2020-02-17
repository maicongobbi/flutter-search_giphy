import 'package:flutter/material.dart';

import 'package:share/share.dart';

//a tela nao mudara, logo é statless
class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        backgroundColor: Colors.black,
        body: Center(
          child: Image.network(
            _gifData["images"]["fixed_height"]["url"],
          ),
        ));
  }

  AppBar _appbar() {
    //String caminhoImagemGiphy ="https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif";
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(_gifData["title"]),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share(_gifData["images"]["fixed_height"]["url"]);
          },
        ),
      ],
    );
  }
}
