import 'dart:convert';
import 'dart:typed_data';

import 'package:primobile/inventario/models/models.dart';
// import 'package:http/http.dart' as http;

class Inventario {
  String documentoNumero;
  String descricao;
  String responsavel;
  List<ArtigoInventario> listaArtigo;
  List _artigosJson = List();

  Inventario(
      {this.documentoNumero,
      this.descricao,
      this.responsavel,
      this.listaArtigo});

  factory Inventario.fromMap(Map<String, dynamic> map) => new Inventario(
        documentoNumero: map['documento_numero'],
        descricao: map['descricao'],
        responsavel: map['responsavel'],
      );

  Map<String, dynamic> toMap() => {
        'documento_numero': documentoNumero,
        'descricao': descricao,
        'responsavel': responsavel,
      };

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      documentoNumero: json['documento_numero'],
      descricao: json['descricao'],
      responsavel: json['responsavel'],
      //  imagemBuffer:  data['imagemBuffer'] ,
    );
  }

  static List<Inventario> parseIventario(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Inventario>((json) => Inventario.fromJson(json)).toList();
  }

  void setListaArtigo(List<ArtigoInventario> artigos) {
    this.listaArtigo = artigos;
  }

  void setArtigo(ArtigoInventario artigo) {
    this.listaArtigo.add(artigo);
  }

  List toMapApi() {
    int i = 0;
    if (listaArtigo != null) {
      listaArtigo.forEach((element) {
        _artigosJson.add(element.toMap());
        //regrasPreco_json.add(regrasPreco[i++].toMap());
      });
    } else {
      _artigosJson = [];
    }

    return [
      {
        'inventario': this.documentoNumero,
        'artigos': _artigosJson,
      }
    ];
  }

  @override
  String toString() => 'Inventario { DocNum: $documentoNumero }';
}
