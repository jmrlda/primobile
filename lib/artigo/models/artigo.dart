import 'dart:convert';
import 'dart:typed_data';
// import 'package:http/http.dart' as http;

class Artigo {
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

  Artigo(
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

  factory Artigo.fromMap(Map<String, dynamic> data) => new Artigo(
        artigo: data['Artigo'],
        descricao: data['Descricao'],
        preco: data['PVP1'],
        quantidade: 1,
        quantidadeStock: 1,
        civa: 1.0,
        iva: 1.0,
        unidade: data['Unidade Base'],
        pvp1: data['PVP1'],
        pvp1Iva: true,
        pvp2: data['PVP2'],
        pvp2Iva: true,
        pvp3: data['PVP3'],
        pvp3Iva: true,
        pvp4: 1.0,
        pvp4Iva: true,
        pvp5: 1.0,
        pvp5Iva: true,
        pvp6: 2,
        pvp6Iva: true,
        imagemBuffer: null,
      );

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
        // 'pvp1Iva': pvp1Iva == true ? 1 : 0,
        'pvp2': pvp2,
        // 'pvp2Iva': pvp2Iva == true ? 1 : 0,
        'pvp3': pvp3,
        // 'pvp3Iva': pvp3Iva == true ? 1 : 0,
        // 'pvp4': pvp4,
        // 'pvp4Iva': pvp4Iva == true ? 1 : 0,
        // 'pvp5': pvp5,
        // 'pvp5Iva': pvp5Iva == true ? 1 : 0,
        // 'pvp6': pvp6,
        // 'pvp6Iva': pvp6Iva == true ? 1 : 0,
      };
  factory Artigo.fromJson(Map<String, dynamic> data) {
    return Artigo(
      artigo: data['Artigo'],
      descricao: data['Descrição'],
      preco: data['PVP1'],
      quantidade: 1,
      quantidadeStock: 1,
      civa: 1.0,
      iva: 1.0,
      unidade: data['Unidade Base'],
      pvp1: data['PVP1'],
      pvp1Iva: true,
      pvp2: data['PVP2'],
      pvp2Iva: true,
      pvp3: data['PVP3'],
      pvp3Iva: true,
      pvp4: 1.0,
      pvp4Iva: true,
      pvp5: 1.0,
      pvp5Iva: true,
      pvp6: 2,
      pvp6Iva: true,
      imagemBuffer: null,
    );
  }

  static List<Artigo> parseArtigos(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Artigo>((json) => Artigo.fromJson(json)).toList();
  }

  @override
  String toString() => 'Artigo { id: $artigo }';
//   static Future<List<Artigo>> fetchArtigos(url) async {
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return Artigo.parseArtigos(response.body);
//     } else {
//       throw Exception('Nao foi possivel obter artigos do REST API');
//     }
//   }
}
