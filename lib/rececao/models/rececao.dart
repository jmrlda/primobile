import 'dart:convert';

import 'package:primobile/rececao/models/models.dart';

class Rececao {
  int rececao;
  String data;
  List<ArtigoRececao> listaArtigo;
  // String listaArtigo;
  String usuario;
  List artigosJson = List();

  Rececao({this.rececao, this.data, this.listaArtigo, this.usuario});

  factory Rececao.fromMap(Map<String, dynamic> json) => new Rececao(
        rececao: json['rececao'],
        data: json['data'],
        listaArtigo: json['listaArtigo'],
        usuario: json['usuario'],
      );

  Map<String, dynamic> toMap() => {
        'rececao': rececao,
        'data': data,
        'listaArtigo': listaArtigo,
        'usuario': usuario,
      };

  factory Rececao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return Rececao(
      rececao: json['Número Documento'],
      usuario: json['Utilizador'],
    );

    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<Rececao> parseRececao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Rececao>((json) => Rececao.fromJson(json)).toList();
  }

  List toMapApi() {
    int i = 0;
    artigosJson.clear();
    if (listaArtigo != null) {
      listaArtigo.forEach((element) {
        artigosJson.add(element.toMap());
      });
    } else {
      artigosJson = [];
    }

    return [
      {
        'rececao': this.rececao,
        'artigos': artigosJson,
      }
    ];
  }
}
