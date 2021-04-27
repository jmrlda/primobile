import 'package:flutter/material.dart';
import 'package:primobile/cliente/util.dart';
import 'package:primobile/util/util.dart';

dynamic inventarioAppBar(BuildContext contexto) {
  // BuildContext contexto;
  return new AppBar(
    backgroundColor: PRIMARY_COLOR,
    actions: [
      PopupMenuButton<String>(
        onSelected: opcaoAcao,
        itemBuilder: (BuildContext context) {
          contexto = context;
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
    title: new Text("Inventarios"),
    leading: new IconButton(
      icon: new Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(contexto),
    ),
  );
}
