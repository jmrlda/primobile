import 'dart:convert';

import 'dart:ffi';

import 'package:primobile/expedicao/models/models.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;

class ArtigoExpedicao {
  String artigo;
  String descricao;
  String unidade;
  double quantidadeExpedir;
  double quantidadePendente;
  String codigoBarra;

  ArtigoExpedicao(
      {this.artigo,
      this.descricao,
      this.unidade,
      this.quantidadeExpedir,
      this.quantidadePendente,
      this.codigoBarra});

  factory ArtigoExpedicao.fromMap(Map<String, dynamic> json) =>
      new ArtigoExpedicao(
          artigo: json['artigo'],
          descricao: json['descricao'],
          quantidadeExpedir: json['quantidade_expedir'],
          quantidadePendente: json['quantidade_pendente'],
          codigoBarra: json['codigo_barra']);

  Map<String, dynamic> toJson() => {
        'artigo': artigo,
        'descricao': descricao,
        'quantidade_expedir': quantidadeExpedir,
        'quantidade_pendente': quantidadePendente,
        'codigo_barra': codigoBarra
      };

  factory ArtigoExpedicao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return ArtigoExpedicao(
        artigo: json['artigo'],
        descricao: json['descricao'],
        quantidadeExpedir: json['quantidade_expedir'],
        quantidadePendente: json['quantidade_pendente'],
        codigoBarra: json['codigo_barra']);
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<ArtigoExpedicao> parseExpedicao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<ArtigoExpedicao>((json) => ArtigoExpedicao.fromJson(json))
        .toList();
  }

  static Future<http.Response> postExpedicao(
      Expedicao expedicao, List<ArtigoExpedicao> lista_artigo) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.readSession();
    String protocolo = 'http://';
    String host = SessaoApiProvider.base_url;
    String rota = '/WebApi/ExpedicaoController/Expedicao/' +
        expedicao.expedicao.toString();
    var url = protocolo + host + rota;
    http.Response response;
    expedicao.listaArtigo = lista_artigo;
    String body = json.encode(expedicao.toMapApi());

    // json.encode(lista_artigo);

    // var response = await http.post(url,
    //     headers: {"Content-Type": "application/json"}, body: body);

    try {
      var sessao = await SessaoApiProvider.readSession();
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return null;
      } else {
        String token = sessao['access_token'];
        response = await http.post(url,
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            },
            body: body);
      }
    } catch (e) {
      throw e;

      // return 3;
    }

    return response;
  }
}
