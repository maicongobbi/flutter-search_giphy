import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seach_giphy/ui/git_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  //qtd de carregamentos a mais
  int _offset = 0;
  Future<Map> _getGifs() async {
    http.Response response;
   if(_search == null || _search.isEmpty){
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=eBDEl3w28r8I3xb5WjjgW4xi8icouNcg&limit=20&rating=G');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=eBDEl3w28r8I3xb5WjjgW4xi8icouNcg&q=$_search&limit=19&offset=$_offset&rating=G&lang=en');
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    //busca os gifs e quando os tiver, then
    _getGifs().then((map) {
      // print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            child: _inputSearch(),
            padding: EdgeInsets.all(10),
          ),
          Expanded(
            child: futureBuilder(),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
    //+1 para adicionar o icone de carregar mais
  }

  FutureBuilder futureBuilder() {
    return FutureBuilder(
      future: _getGifs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                //indica que colocara uma cor e amesma não mudará, ficara sempre na cor branca
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 5,
              ),
            );

            break;
          default:
            if (snapshot.hasError)
              return Container();
            else
              return _createGifTable(context, snapshot);
        }
      },
    );
  }

  TextField _inputSearch() {
    return TextField(
      onSubmitted: (text) {
        setState(() {
          _search = text;
          _offset = 0;
        });
      },
      decoration: InputDecoration(
        labelText: "Search here:",
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      textAlign: TextAlign.center,
    );
  }

/// aula 84
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      //mostra como os itens vão ser organizados
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //item na horzontal
          crossAxisCount: 2,
          //espaco entre os 2 elementos
          crossAxisSpacing: 10.0,
          //espaçamento na hotizontal
          mainAxisSpacing: 10),
      //qtd de itens na tela
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
//retorna o item que vai aparecer na tela
//deixando a imagem clicavel
/**
 * se eu não estiver pesquisando eu mostro mimnha imagem ou
 * pesquisando e o index ainda não é o úiltimo
 */
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                //retorna a nova tela
                builder: (context) => GifPage(snapshot.data["data"][index])
              ) );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
            child: FadeInImage.memoryNetwork(
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"], 
              height: 300,
              fit: BoxFit.cover,
              //usandoplugin para usarimagem transparente
              placeholder: kTransparentImage,)
          );
        } else {
          return GestureDetector(
            onTap: (){
              //ao clicar pega mais 19 gifs
              setState(() {
                _offset +=19;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Colors.yellow, size: 70.05,),
                Text(
                  "Carregar",
                  style: TextStyle(
                    color: Colors.white, fontSize: 22
                  ),
                )

              ],
            ),
          );
        }
      },
    );
  }
}

AppBar _appbar() {
  String caminhoImagemGiphy =
      "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif";
  return AppBar(
    backgroundColor: Colors.black,
    title: Image.network(caminhoImagemGiphy),
    centerTitle: true,
  );
}
