import 'package:flutter/material.dart';
import 'package:primobile/cliente/util.dart';
import 'package:primobile/util/util.dart';

dynamic expedicaoAppBar(BuildContext contexto) {
  // BuildContext contexto;
  return new AppBar(
    backgroundColor: Colors.blue,
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
    title: new Text("Inventario"),
    leading: new IconButton(
      icon: new Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(contexto),
    ),
  );
}
