import 'dart:convert';

import 'package:primobile/expedicao/models/artigo_expedicao.dart';

class Expedicao {
  int expedicao;
  String data;
  // List<ArtigoExpedicao> listaArtigo;
  String listaArtigo;
  String usuario;

  Expedicao({this.expedicao, this.data, this.listaArtigo, this.usuario});

  factory Expedicao.fromMap(Map<String, dynamic> json) => new Expedicao(
        expedicao: json['expedicao'],
        data: json['data'],
        listaArtigo: json['listaArtigo'],
        usuario: json['usuario'],
      );

  Map<String, dynamic> toMap() => {
        'expedicao': expedicao,
        'data': data,
        'listaArtigo': listaArtigo,
        'usuario': usuario,
      };

  factory Expedicao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return Expedicao(
      expedicao: json['Número Documento'],
      // data: json['data'],
      // listaArtigo: json['listaArtigo'],
      usuario: json['Utilizador'],
    );
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<Expedicao> parseExpedicao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Expedicao>((json) => Expedicao.fromJson(json)).toList();
  }
}
