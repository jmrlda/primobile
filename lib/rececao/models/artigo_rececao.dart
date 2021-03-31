import 'dart:convert';

import 'dart:ffi';

class ArtigoRececao {
  String artigo;
  String descricao;
  String unidade;
  Double quantidadeRecebida;
  Double quantidadeRejeitada;

  ArtigoRececao(
      {this.artigo,
      this.descricao,
      this.unidade,
      this.quantidadeRecebida,
      this.quantidadeRejeitada});

  factory ArtigoRececao.fromMap(Map<String, dynamic> json) => new ArtigoRececao(
        artigo: json['artigo'],
        descricao: json['descricao'],
        unidade: json['unidade'],
        quantidadeRecebida: json['quantidadeRecebida'],
        quantidadeRejeitada: json['quantidadeRejeitada'],
      );

  Map<String, dynamic> toMap() => {
        'artigo': artigo,
        'descricao': descricao,
        'unidade': unidade,
        'quantidadeRecebida': quantidadeRecebida,
        'quantidadeRejeitada': quantidadeRejeitada,
      };

  factory ArtigoRececao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return ArtigoRececao(
      artigo: json['artigo'],
      descricao: json['descricao'],
      unidade: json['unidade'],
      quantidadeRecebida: json['quantidadeRecebida'],
      quantidadeRejeitada: json['quantidadeRejeitada'],
    );
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<ArtigoRececao> parseRececao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<ArtigoRececao>((json) => ArtigoRececao.fromJson(json))
        .toList();
  }
}
