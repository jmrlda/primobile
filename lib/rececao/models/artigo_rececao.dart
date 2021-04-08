import 'dart:convert';

import 'dart:ffi';

import 'package:primobile/rececao/models/models.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;

class ArtigoRececao {
  String artigo;
  String descricao;
  String unidade;
  double quantidadeRecebida;
  double quantidadeRejeitada;

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
        quantidadeRecebida: json['quantidade_recebida'],
        quantidadeRejeitada: json['quantidade_rejeitada'],
      );

  Map<String, dynamic> toMap() => {
        'artigo': artigo,
        'descricao': descricao,
        'quantidade_recebida': quantidadeRecebida,
        'quantidade_rejeitada': quantidadeRejeitada,
      };

  factory ArtigoRececao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return ArtigoRececao(
      artigo: json['artigo'],
      descricao: json['descricao'],
      quantidadeRecebida: double.parse(json['quantidade_recebida']),
      quantidadeRejeitada: double.parse(json['quantidade_rejeitada']),
    );
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<ArtigoRececao> parseRececao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<ArtigoRececao>((json) => ArtigoRececao.fromJson(json))
        .toList();
  }

  static Future<http.Response> postRececao(
      Rececao rececao, List<ArtigoRececao> lista_artigo) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.read();
    String protocolo = 'http://';
    String host = SessaoApiProvider.base_url;
    String rota =
        '/WebApi/RececaoController/Rececao/' + rececao.rececao.toString();
    var url = protocolo + host + rota;
    http.Response response;
    rececao.listaArtigo = lista_artigo;

    // json.encode(lista_artigo);

    // var response = await http.post(url,
    //     headers: {"Content-Type": "application/json"}, body: body);

    try {
      String body = json.encode(rececao.toMapApi());

      var sessao = await SessaoApiProvider.read();
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
