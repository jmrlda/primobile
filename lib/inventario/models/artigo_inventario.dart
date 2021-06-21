import 'dart:convert';

import 'dart:ffi';

import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;

class ArtigoInventario {
  String id;
  String artigo;
  String descricao;
  String unidade;
  double quantidadeStock;
  double quantidadeStockReserva;

  String codigoBarra;
  String armazem;

  String localizacao;
  String lote;
  Artigo artigoObj;

  ArtigoInventario(
      {this.id,
      this.artigo,
      this.descricao,
      this.unidade,
      this.quantidadeStock,
      this.codigoBarra,
      this.armazem,
      this.lote,
      this.localizacao,
      this.quantidadeStockReserva});

  factory ArtigoInventario.fromMap(Map<String, dynamic> map) =>
      new ArtigoInventario(
          id: map['id'],
          artigo: map['artigo'],
          descricao: map['descricao'],
          quantidadeStock: double.tryParse(map['quantidade_stock'] ?? 0.0),
          codigoBarra: map['codigo_barra'],
          armazem: map['armazem'] ?? "",
          lote: map['lote'],
          localizacao: map['localizacao'],
          unidade: map['unidade'],
          quantidadeStockReserva:
              double.tryParse(map['quantidade_reserva'] ?? 0.0));

  Map<String, dynamic> toJson() => {
        'id': id,
        'artigo': artigo,
        'descricao': descricao,
        'quantidade_stock': quantidadeStock,
        'codigo_barra': codigoBarra,
        'armazem': armazem,
        'lote': lote,
        'localizacao': localizacao,
        'unidade': unidade,
        'quantidade_reserva': quantidadeStockReserva,
        'artigoObj': artigoObj.toJson()
      };

  factory ArtigoInventario.fromJson(Map<String, dynamic> json) {
    return ArtigoInventario(
        id: json['id'],
        artigo: json['artigo'],
        descricao: json['descricao'],
        quantidadeStock: double.tryParse(json['quantidade_stock'] ?? 0.0),
        codigoBarra: json['codigo_barra'],
        armazem: json['armazem'] ?? "",
        lote: json['lote'],
        localizacao: json['localizacao'],
        unidade: json['unidade'],
        quantidadeStockReserva:
            double.tryParse(json['quantidade_reserva'] ?? 0.0));
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
