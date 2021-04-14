import 'package:flutter/material.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/util/util.dart';

BuildContext contexto;

AppBar menuAppBar() {
  return new AppBar(
    title: new Center(
      child: Text('Menu'),
    ),
    backgroundColor: Colors.blue,
    actions: <Widget>[
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
  );
}

void opcaoAcao(String opcao) async {
  if (opcao == Opcoes.Login) {
    await Navigator.pushNamed(contexto, '/');
  } else if (opcao == Opcoes.Configurar) {
    await Navigator.pushNamed(contexto, '/config_instancia');
  }
}
