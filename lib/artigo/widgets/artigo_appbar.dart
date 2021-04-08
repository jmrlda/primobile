import 'package:flutter/material.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/util/util.dart';

dynamic artigoAppBar(BuildContext context) {
  return new AppBar(
    backgroundColor: Colors.blue,
    actions: [
      PopupMenuButton<String>(
        onSelected: opcaoAcao,
        itemBuilder: (BuildContext context) {
          return Opcoes.escolha.map((String escolha) {
            return PopupMenuItem<String>(
              value: escolha,
              child: Text(escolha),
            );
          }).toList();
        },
      )
    ],
    centerTitle: true,
    title: new Text("Artigos"),
    leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        }),
  );
}
