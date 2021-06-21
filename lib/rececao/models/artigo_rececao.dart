import 'dart:convert';

import 'dart:ffi';

import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/rececao/models/models.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;

class ArtigoRececao {
  String artigo;
  String descricao;
  String unidade;
  String codigoBarra;
  double quantidadeRecebida;
  double quantidadeRejeitada;
  String armazem;
  String localizacao;
  String lote;
  Artigo artigoObj;

  ArtigoRececao(
      {this.artigo,
      this.descricao,
      this.unidade,
      this.codigoBarra,
      this.quantidadeRecebida,
      this.quantidadeRejeitada,
      this.armazem = "",
      this.lote = "",
      this.localizacao = ""});

  factory ArtigoRececao.fromMap(Map<String, dynamic> json) => new ArtigoRececao(
      artigo: json['artigo'] ?? "",
      descricao: json['descricao'] ?? "",
      unidade: json['unidade'] ?? "",
      quantidadeRecebida: json['quantidade_recebida'] ?? "",
      quantidadeRejeitada: json['quantidade_rejeitada'] ?? "",
      codigoBarra: json['codigo_barra'] ?? "",
      armazem: json['armazem'] ?? "",
      lote: json['lote'],
      localizacao: json['localizacao'] ?? "");

  Map<String, dynamic> toJson() => {
        'artigo': artigo,
        'descricao': descricao,
        'quantidadeRecebida': quantidadeRecebida,
        'quantidadeRejeitada': quantidadeRejeitada,
        'codigo_barra': codigoBarra,
        'armazem': armazem,
        'lote': lote,
        'localizacao': localizacao,
        'artigoObj': artigoObj.toJson()
      };

  factory ArtigoRececao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return ArtigoRececao(
        artigo: json['artigo'] ?? "",
        descricao: json['descricao'] ?? "",
        unidade: json['unidade'] ?? "",
        quantidadeRecebida:
            double.tryParse(json['quantidadeRecebida'].toString() ?? 0.0),
        quantidadeRejeitada:
            double.tryParse(json['quantidadeRejeitada'].toString() ?? 0.0),
        codigoBarra: json['codigo_barra'] ?? "",
        armazem: json['armazem'] ?? "",
        lote: json['lote'],
        localizacao: json['localizacao'] ?? "");

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
    Map<String, dynamic> parsed = await SessaoApiProvider.readSession();
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

      var sessao = await SessaoApiProvider.readSession();
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessão não existe');
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

  void setArtigo(List<Artigo> lstArtigos) {
    lstArtigos.forEach((_artigo) {
      if (_artigo.artigo == this.artigo) {
        this.artigoObj = _artigo;
        return;
      }
    });
  }

  void setQuantidadePorArmazem(dynamic json) {
    this.artigoObj.artigoArmazem.forEach((_artigo) {
      if (_artigo.armazem == json['armazem'] &&
          _artigo.lote == json['lote'] &&
          _artigo.localizacao == json['localizacao']) {
        _artigo.quantidadeRecebido = json['quantidadeRecebido'];
        _artigo.quantidadeRejeitada = json['quantidadeRejeitada'];

        return;
      }
    });
  }
}
