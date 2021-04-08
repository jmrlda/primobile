import 'dart:convert';

import 'package:primobile/expedicao/models/artigo_expedicao.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

class Expedicao {
  int expedicao;
  String data;
  List<ArtigoExpedicao> listaArtigo;
  // String listaArtigo;
  String usuario;
  List artigosJson = List();

  Expedicao({this.expedicao, this.data, this.listaArtigo, this.usuario});

  factory Expedicao.fromMap(Map<String, dynamic> json) => new Expedicao(
        expedicao: json['expedicao'],
        data: json['data'],
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

  void setListaArtigo(List<ArtigoExpedicao> artigos) {
    this.listaArtigo = artigos;
  }

  void setArtigo(ArtigoExpedicao artigo) {
    this.listaArtigo.add(artigo);
  }

  List toMapApi() {
    int i = 0;
    if (listaArtigo != null) {
      listaArtigo.forEach((element) {
        artigosJson.add(element.toMap());
        //regrasPreco_json.add(regrasPreco[i++].toMap());
      });
    } else {
      artigosJson = [];
    }

    return [
      {
        'expedicao': this.expedicao,
        'artigos': artigosJson,
      }
    ];
  }
}
