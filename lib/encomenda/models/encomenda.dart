import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:primobile/artigo/artigos.dart';
import 'package:primobile/cliente/cliente.dart';
import 'package:primobile/database/database.dart';
import 'package:primobile/regras_negocio/models/regras_negocio.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/usuario/models/models.dart';
import 'package:dio/dio.dart';
import 'package:primobile/util/util.dart';

// import 'package:primobile/encomenda/regraPrecoDesconto_modelo.dart';
// import 'package:primobile/sessao/sessao_api_provider.dart';
// import 'package:intl/intl.dart';

// import '../util.dart';

class Encomenda {
  int id;
  Cliente cliente;
  Usuario vendedor;
  List<Artigo> artigos;
  List artigosJson = List();
  double valorTotal;
  String estado;
  DateTime dataHora;
  String encomenda_id;
  String latitude;
  String longitude;
  String assinaturaImagemBuffer;
  List<RegraPrecoDesconto> regrasPreco = List<RegraPrecoDesconto>();
  List regrasPreco_json = List();

  Encomenda(
      {this.id,
      this.cliente,
      this.vendedor,
      this.artigos,
      this.valorTotal,
      this.estado,
      this.dataHora,
      this.encomenda_id,
      this.latitude,
      this.longitude,
      this.assinaturaImagemBuffer,
      this.regrasPreco});

  factory Encomenda.fromMap(Map<String, dynamic> json) {
    Usuario usuario;
    // senha: 'rere');

    Cliente cliente = Cliente(cliente: json['cliente']);
    Future<Map<String, dynamic>> sessao = null;
    sessao.then((value) => {});
    return new Encomenda(
        id: json['encomenda'],
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.tryParse(json['data_hora']),
        encomenda_id: json['encomenda_id'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        assinaturaImagemBuffer: json['assinaturaImagemBuffer'],
        regrasPreco: json['regrasPreco']);
  }

  factory Encomenda.fromMap_2(Map<String, dynamic> json, Cliente cliente) {
    Usuario usuario;
    // Cliente cliente = Cliente(cliente: json['cliente']);
    return new Encomenda(
        id: int.parse(json['encomenda']),
        cliente: cliente,
        vendedor: usuario,
        artigos: List<Artigo>(),
        valorTotal: json['valor'],
        estado: json['estado'],
        dataHora: DateTime.now(),
        // DateFormat('dd-MM-yyyy HH:mm:ss')
        // .parse(json['data_hora'].toString()),
        encomenda_id: json['encomenda_id'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        assinaturaImagemBuffer: json['assinaturaImagemBuffer'],
        regrasPreco: json['regrasPreco']);
  }

  Map<String, dynamic> toMap() => {
        'cliente': cliente.cliente,
        'vendedor': vendedor.usuario,
        // 'artigos': artigos,
        'valor': valorTotal,
        'estado': estado,
        'data_hora': dataHora.toString(),
        'encomenda_id': this.encomenda_id,
        'latitude': latitude,
        'longitude': longitude,
        'assinaturaImagemBuffer': assinaturaImagemBuffer,
        // 'regrasPreco' : regrasPreco.
      };

  List toMapApi() {
    int i = 0;
    if (artigos != null) {
      artigos.forEach((element) {
        artigosJson.add(element.toMap());
        //regrasPreco_json.add(regrasPreco[i++].toMap());
      });
    } else {
      artigosJson = [];
      regrasPreco_json = [];
    }

    return [
      {
        'cliente': cliente.toMap(),
        'vendedor': vendedor.toMap(),
        'artigos': artigosJson,
        'valorTotal': valorTotal,
        'estado': estado,
        'dataHora': dataHora.toString(),
        'encomenda_id': this.encomenda_id,
        'latitude': latitude,
        'longitude': longitude,
        'assinaturaImagemBuffer': assinaturaImagemBuffer,
        'regras': regrasPreco_json
      }
    ];
  }

  Map<String, dynamic> ItemtoMap() => {
        'encomenda': id,
        'artigo': vendedor.usuario,
        'valor_unit': artigos,
        'quantidade': valorTotal,
        'valor_total': estado,
      };

  factory Encomenda.fromJson(Map<String, dynamic> data) {
    List artigosJson = data['artigos'];
    List regra_json = data['regras'];

    List<Artigo> lista_artigo = new List<Artigo>();
    List<RegraPrecoDesconto> lista_regra = new List<RegraPrecoDesconto>();

    for (int i = 0; i < artigosJson.length; i++) {
      lista_artigo.add(Artigo.fromJson(artigosJson[i]));
      lista_regra.add(RegraPrecoDesconto.fromJson(regra_json[i]));
    }
    try {
      String datatime = data['dataHora'].toString().replaceAll('/', '-');
      return Encomenda(
          cliente: Cliente.fromJson(data['cliente']),
          vendedor: Usuario.fromJson(data['vendedor']),
          artigos: lista_artigo,
          valorTotal: double.parse(data['valorTotal'].toString()),
          estado: data['estado'],
          dataHora: DateTime
              .now(), //new DateFormat("yyyy-MM-dd HH:mm:ss").parse(datatime),
          encomenda_id: data['encomenda_id'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          assinaturaImagemBuffer: data['assinaturaImagemBuffer'],
          regrasPreco: lista_regra);
    } catch (e) {
      print('Ocorreu um erro');
      print(e.message);
      return Encomenda();
    }
  }

  List<Encomenda> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Encomenda>((json) => Encomenda.fromJson(json)).toList();
  }

  static Future<Cliente> getCliente(String cliente) async {
    Cliente cli = null; // await DBProvider.db.getCliente(cliente);
    return cli;
  }

  static void getVendedor(String usuario) async {
    // await DBProvider.db.getUsuario(usuario);
  }

  Future<Object> setLocalizacao() async {
    // // Position posicao;
    // try {
    //  posicao = await  GetLocalizacaoActual();
    // if ( posicao != null) {
    //   this.latitude = posicao.latitude.toString();
    //   this.longitude = posicao.longitude.toString();
    //
    // } else {
    //
    //   throw Exception("Não foi possivel encontrar a localização");
    // }
    //
    // } catch(ex) {
    //   this.latitude = "0";
    //   this.longitude = "0";
    // }
    //
    //   // this.latitude = "0";
    //   // this.longitude = "0";
    // return posicao;
    return null;
  }

  static Future<http.Response> postEncomenda(Encomenda encomenda) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.readSession();
    String protocolo = 'http://';
    String host = SessaoApiProvider.base_url;
    String rota = '/WebApi/EncomendaController/Encomenda/ecl/2021/' +
        encomenda.cliente.cliente;
    var url = protocolo + host + rota;
    http.Response response;

    String body = json.encode(encomenda.toMapApi());

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

  /// @postEncomendaAssinatura - metodo responsavel por enviar imagem contendo assinatura do cliente como

  ///  comprovativo da encomenda.

  /// @ argumento

  ///  # encomenda - necessario para criar a url da encomenda

  ///  # filename - nome que sera usado para armazenar a imagem

  ///  # assinatura - bytes da imagem contendo a assinatura

  /// @ retorno - HTTP response contendo o codigo de status do carregamento da assinatura

  static Future<int> postEncomendaAssinatura(Encomenda encomenda,
      String filename, dynamic assinatura, File file) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.readSession();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/ImagemUpload/encomenda/' +
        encomenda.encomenda_id.replaceAll('/', '_');
    String url = protocolo + host + rota;
    print('url' + url);
    Response response;
    try {
      response = await uploadImage(file, url);
      // verificar o codigo do status

    } catch (e) {
      print("[postEncomendaAssinatura] erro: Exception");
      print(e);
    }

    return response.statusCode;
  }

  static Future<bool> removeEncomendaByid(int id) async {
    bool rv = false;
    try {
      rv = await DBProvider.db.removeEncomendaById(id);
    } catch (err) {
      rv = false;
    }

    return rv;
  }

  static Future<http.Response> postBuscarDesconto(Encomenda encomenda) async {
    Map<String, dynamic> parsed = await SessaoApiProvider.readSession();
    Map<String, dynamic> filial = parsed['resultado'];
    String protocolo = 'http://';
    String host = filial['empresa_filial']['ip'];
    String rota = '/api/RegrasPrecoDesconto';
    var url = protocolo + host + rota;
    Map mapa = new Map();
    List<String> artigoPromo = new List<String>();

    encomenda.artigos.forEach((element) {
      artigoPromo.add(element.artigo);
    });

    mapa["cliente"] = encomenda.cliente.cliente;
    mapa["artigo"] = artigoPromo;

    var body = json.encode(mapa);
    var response;
    try {
      response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
    } catch (err) {
      response = err;
    }

    // verificar o codigo do status
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
