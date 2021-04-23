import 'dart:convert';

import 'dart:ffi';

import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;

class ArtigoInventario {
  String artigo;
  String descricao;
  String unidade;
  double quantidadeStock;
  double quantidadeStockReserva;

  String codigoBarra;
  String localizacao;
  String lote;

  ArtigoInventario(
      {this.artigo,
      this.descricao,
      this.unidade,
      this.quantidadeStock,
      this.codigoBarra,
      this.lote,
      this.localizacao,
      this.quantidadeStockReserva});

  factory ArtigoInventario.fromMap(Map<String, dynamic> map) =>
      new ArtigoInventario(
          artigo: map['artigo'],
          descricao: map['descricao'],
          quantidadeStock: double.parse(map['quantidade_stock']),
          codigoBarra: map['codigo_barra'],
          lote: map['lote'],
          localizacao: map['localizacao'],
          unidade: map['unidade'],
          quantidadeStockReserva: double.parse(map['quantidade_reserva']));

  Map<String, dynamic> toMap() => {
        'artigo': artigo,
        'descricao': descricao,
        'quantidade_stock': quantidadeStock,
        'codigo_barra': codigoBarra,
        'lote': lote,
        'localizacao': localizacao,
        'unidade': unidade,
        'quantidade_reserva': quantidadeStockReserva,
      };

  factory ArtigoInventario.fromJson(Map<String, dynamic> json) {
    return ArtigoInventario(
        artigo: json['artigo'],
        descricao: json['descricao'],
        quantidadeStock: double.parse(json['quantidade_stock']),
        codigoBarra: json['codigo_barra'],
        lote: json['lote'],
        localizacao: json['localizacao'],
        unidade: json['unidade'],
        quantidadeStockReserva: double.parse(json['quantidade_reserva']));
  }

  List<ArtigoInventario> parseInventario(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<ArtigoInventario>((json) => ArtigoInventario.fromJson(json))
        .toList();
  }

  static Future<http.Response> postInventario(
      Inventario inventario, List<ArtigoInventario> lista_artigo) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.readSession();
    String protocolo = 'http://';
    String host = SessaoApiProvider.base_url;
    String rota = '/WebApi/InventarioStockController/Inventario/' +
        inventario.documentoNumero.toString();
    var url = protocolo + host + rota;
    http.Response response;
    inventario.listaArtigo = lista_artigo;
    String body = json.encode(inventario.toMapApi());

    // json.encode(lista_artigo);

    // var response = await http.post(url,
    //     headers: {"Content-Type": "application/json"}, body: body);

    try {
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
}
