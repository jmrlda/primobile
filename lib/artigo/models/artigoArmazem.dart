import 'dart:convert';
import 'dart:typed_data';
// import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ArtigoArmazem {
  String id = Uuid().v4();

  String artigo;
  String armazem;
  String localizacao;

  String lote;
  double quantidadeStock;
  double quantidade = 0.0;
  String estado;
  double quantidadeExpedir;
  double quantidadePendente;
  double quantidadeRecebido;
  double quantidadeRejeitada;

  ArtigoArmazem(
      {this.artigo,
      this.armazem,
      this.localizacao,
      this.lote,
      this.quantidadeStock,
      this.quantidade,
      this.estado,
      this.quantidadeRecebido,
      this.quantidadeRejeitada,
      this.quantidadeExpedir,
      this.quantidadePendente});

  factory ArtigoArmazem.fromMap(Map<String, dynamic> data) {
    try {
      return new ArtigoArmazem(
        // id: data['id'],
        artigo: data['artigo'],
        armazem: data['armazem'] ?? "@",
        localizacao: data['localizacao'] ?? "@",
        lote: data['lote'] ?? "@",
        quantidadeStock:
            double.tryParse(data['quantidadeStock'].toString()) ?? 0.0,
        quantidade: double.tryParse(data['quantidade'].toString()) ?? 0.0,
        estado: data['estado'] ?? "",
        quantidadeExpedir: double.tryParse(data['quantidade_expedir']) ?? 0.0,
        quantidadePendente: double.tryParse(data['quantidade_pendente']) ?? 0.0,
        quantidadeRecebido: double.tryParse(data['quantidadeRecebido']) ?? 0.0,
        quantidadeRejeitada:
            double.tryParse(data['quantidadeRejeitada']) ?? 0.0,
      );
    } catch (e) {
      return null;
    }
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'artigo': artigo,
        'armazem': armazem,
        'localizacao': localizacao,
        'lote': lote,
        'quantidadeStock': quantidadeStock,
        'quantidade': quantidade,
        'estado': estado,
        'quantidadeExpedir': quantidadeExpedir,
        'quantidadePendente': quantidadePendente,
        'quantidadeRecebido': quantidadeRecebido,
        'quantidadeRejeitada': quantidadeRejeitada
      };

  factory ArtigoArmazem.fromJson(Map<String, dynamic> data) {
    return ArtigoArmazem(
      // id: data['id'],
      artigo: data['artigo'],
      armazem: data['armazem'] ?? "@",
      localizacao: data['localizacao'] ?? "@",
      lote: data['lote'] ?? "@",
      quantidadeStock:
          double.tryParse(data['quantidadeStock'].toString()) ?? 0.0,
      quantidade: double.tryParse(data['quantidade'].toString()) ?? 0.0,
      estado: data['estado'] ?? "",
      quantidadeExpedir: data['quantidade_expedir'] ?? 0.0,
      quantidadePendente: data['quantidade_pendente'] ?? 0.0,
      quantidadeRecebido: double.tryParse(data['quantidadeRecebido'] ?? "0.0"),
      quantidadeRejeitada:
          double.tryParse(data['quantidadeRejeitada'] ?? "0.0"),
    );
  }

  static List<ArtigoArmazem> parseArtigos(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<ArtigoArmazem>((json) => ArtigoArmazem.fromJson(json))
        .toList();
  }

  @override
  String toString() =>
      'ArtigoArmazem { id: $id, artigo: $artigo , armazem: $armazem, localizacao: $localizacao, lote: $lote, stock: $quantidadeStock, qtd: $quantidade}';

  String artigoArmazemId() => id;
  // '$artigo:$armazem:$localizacao:$lote:$quantidadeStock';
}
