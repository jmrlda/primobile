import 'package:flutter/material.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/util/util.dart';

dynamic fornecedorAppBar(BuildContext context) {
  return new AppBar(
    backgroundColor: PRIMARY_COLOR,
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
    title: new Text("Fornecedor"),
    leading: new IconButton(
      icon: new Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}
