import 'dart:convert';

import 'dart:ffi';

class ArtigoExpedicao {
  String artigo;
  String descricao;
  String unidade;
  Double quantidadeExpedir;
  Double quantidadePendente;

  ArtigoExpedicao(
      {this.artigo,
      this.descricao,
      this.unidade,
      this.quantidadeExpedir,
      this.quantidadePendente});

  factory ArtigoExpedicao.fromMap(Map<String, dynamic> json) =>
      new ArtigoExpedicao(
        artigo: json['artigo'],
        descricao: json['descricao'],
        unidade: json['unidade'],
        quantidadeExpedir: json['quantidadeExpedir'],
        quantidadePendente: json['quantidadePendente'],
      );

  Map<String, dynamic> toMap() => {
        'artigo': artigo,
        'descricao': descricao,
        'unidade': unidade,
        'quantidadeExpedir': quantidadeExpedir,
        'quantidadePendente': quantidadePendente,
      };

  factory ArtigoExpedicao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return ArtigoExpedicao(
      artigo: json['artigo'],
      descricao: json['descricao'],
      unidade: json['unidade'],
      quantidadeExpedir: json['quantidadeExpedir'],
      quantidadePendente: json['quantidadePendente'],
    );
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<ArtigoExpedicao> parseExpedicao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<ArtigoExpedicao>((json) => ArtigoExpedicao.fromJson(json))
        .toList();
  }
}
