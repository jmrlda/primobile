import 'dart:convert';
import 'dart:typed_data';
// import 'package:http/http.dart' as http;

class Fornecedor {
  String artigo;
  String descricao;
  double preco;
  double quantidade;
  double quantidadeStock;
  double civa;
  double iva;
  String unidade;
  double pvp1;
  bool pvp1Iva;
  double pvp2;
  bool pvp2Iva;
  double pvp3;
  bool pvp3Iva;
  double pvp4;
  bool pvp4Iva;
  double pvp5;
  bool pvp5Iva;
  double pvp6;
  bool pvp6Iva;
  Uint8List imagemBuffer;
  String imagemBufferStr;

  Fornecedor(
      {this.artigo,
      this.descricao,
      this.preco,
      this.quantidade = 1,
      this.quantidadeStock,
      this.civa,
      this.iva,
      this.unidade,
      this.pvp1,
      this.pvp1Iva,
      this.pvp2,
      this.pvp2Iva,
      this.pvp3,
      this.pvp3Iva,
      this.pvp4,
      this.pvp4Iva,
      this.pvp5,
      this.pvp5Iva,
      this.pvp6,
      this.pvp6Iva,
      this.imagemBuffer,
      this.imagemBufferStr});

  factory Fornecedor.fromMap(Map<String, dynamic> json) => new Fornecedor(
      artigo: json['artigo'],
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      quantidadeStock: json['quantidadeStock'],
      civa: json['civa']?.toDouble(),
      iva: json['iva']?.toDouble(),
      unidade: json['unidade'],
      // imagemBuffer: json['imagemBuffer'] ,
      imagemBuffer: json['imagemBuffer'] != null ? null : json['imagemBuffer'],
      pvp1: json['pvp1'].toDouble(),
      pvp1Iva: json['pvp1Iva'] == 1 ? true : false,
      pvp2: json['pvp2'].toDouble(),
      pvp2Iva: json['pvp2Iva'] == 1 ? true : false,
      pvp3: json['pvp3'].toDouble(),
      pvp3Iva: json['pvp3Iva'] == 1 ? true : false,
      pvp4: json['pvp4'].toDouble(),
      pvp4Iva: json['pvp4Iva'] == 1 ? true : false,
      pvp5: json['pvp5'].toDouble(),
      pvp5Iva: json['pvp5Iva'] == 1 ? true : false,
      pvp6: json['pvp6'].toDouble(),
      pvp6Iva: json['pvp6Iva'] == 1 ? true : false);

  Map<String, dynamic> toMap() => {
        'artigo': artigo,
        'descricao': descricao,
        'preco': preco,
        'quantidadeStock': quantidadeStock,
        'quantidade': quantidade,
        'civa': civa,
        'iva': iva,
        'unidade': unidade,
        'imagemBuffer': imagemBuffer,
        'pvp1': pvp1,
        'pvp1Iva': pvp1Iva == true ? 1 : 0,
        'pvp2': pvp2,
        'pvp2Iva': pvp2Iva == true ? 1 : 0,
        'pvp3': pvp3,
        'pvp3Iva': pvp3Iva == true ? 1 : 0,
        'pvp4': pvp4,
        'pvp4Iva': pvp4Iva == true ? 1 : 0,
        'pvp5': pvp5,
        'pvp5Iva': pvp5Iva == true ? 1 : 0,
        'pvp6': pvp6,
        'pvp6Iva': pvp6Iva == true ? 1 : 0,
      };

  Map<String, dynamic> imagemToMap() =>
      {'artigo': this.artigo, 'imagemBuffer': this.imagemBuffer};

  Map<String, dynamic> toMapDb() => {
        'artigo': artigo,
        'descricao': descricao,
        'preco': preco,
        'quantidadeStock': quantidadeStock,
        'civa': civa,
        'iva': iva,
        'unidade': unidade,
        'imagemBuffer': imagemBuffer,
        'pvp1': pvp1,
        'pvp1Iva': pvp1Iva == true ? 1 : 0,
        'pvp2': pvp2,
        'pvp2Iva': pvp2Iva == true ? 1 : 0,
        'pvp3': pvp3,
        'pvp3Iva': pvp3Iva == true ? 1 : 0,
        'pvp4': pvp4,
        'pvp4Iva': pvp4Iva == true ? 1 : 0,
        'pvp5': pvp5,
        'pvp5Iva': pvp5Iva == true ? 1 : 0,
        'pvp6': pvp6,
        'pvp6Iva': pvp6Iva == true ? 1 : 0,
      };
  factory Fornecedor.fromJson(Map<String, dynamic> data) {
    return Fornecedor(
      artigo: data['artigo'],
      descricao: data['descricao'],
      preco: data['preco'].toDouble(),
      quantidade: data['quantidade'].toDouble(),
      quantidadeStock: data['quantidade'].toDouble(),
      civa: data['civa']?.toDouble(),
      iva: data['iva']?.toDouble(),
      unidade: data['unidade'],
      pvp1: data['pvp1'].toDouble(),
      pvp1Iva: data['pvp1Iva'],
      pvp2: data['pvp2'].toDouble(),
      pvp2Iva: data['pvp2Iva'],
      pvp3: data['pvp3'].toDouble(),
      pvp3Iva: data['pvp3Iva'],
      pvp4: data['pvp4'].toDouble(),
      pvp4Iva: data['pvp4Iva'],
      pvp5: data['pvp5'].toDouble(),
      pvp5Iva: data['pvp5Iva'],
      pvp6: data['pvp6'].toDouble(),
      pvp6Iva: data['pvp6Iva'],
      //  imagemBuffer:  data['imagemBuffer'] ,
    );
  }

  static List<Fornecedor> parseArtigos(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Fornecedor>((json) => Fornecedor.fromJson(json)).toList();
  }

  @override
  String toString() => 'Fornecedor { id: $artigo }';
}
