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
  String codigoBarra;
  List<ArtigoArmazem> artigoArmazem = new List<ArtigoArmazem>();

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
      this.imagemBufferStr,
      this.codigoBarra,
      this.artigoArmazem});

  Map<String, dynamic> toJson() => {
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
        'artigoArmazem': this.listaArmazemToJson()
      };

  Map<String, dynamic> imagemToMap() =>
      {'artigo': this.artigo, 'imagemBuffer': this.imagemBuffer};

  factory Artigo.fromJson(Map<String, dynamic> data) {
    Artigo _artigo = new Artigo(
      artigo: data['artigo'],
      descricao: data['descricao'],
      preco: data['pvp1'],
      quantidade: 0,
      quantidadeStock: double.tryParse(
          data['totalStock'].toString() ?? data['quantidadeStock'].toString()),
      civa: 1.0,
      iva: 1.0,
      unidade: data['unidade'],
      pvp1: data['pvp1'],
      pvp1Iva: true,
      pvp2: data['pvp2'],
      pvp2Iva: true,
      pvp3: data['pvp3'],
      pvp3Iva: true,
      pvp4: data['pvp4'],
      pvp4Iva: true,
      pvp5: data['pvp5'],
      pvp5Iva: true,
      pvp6: data['pvp6'],
      pvp6Iva: true,
      imagemBuffer: null,
      codigoBarra: data['codigoBarra'] ?? "",
      armazem: data['armazem'] ?? "",
      localizacao: data['localizacao'] ?? "",
      lote: data['lote'] ?? "",
    );
  }

  static List<Artigo> parseArtigos(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Artigo>((json) => Artigo.fromJson(json)).toList();
  }

  @override
  String toString() => 'Artigo { id: $artigo }';

  // verificar se o artigo currente possui o mesmo codigo de barra que o do parametro
  bool existeArtigoByCodigoBarra(String codigoBarra) {
    if (this.codigoBarra != null || this.codigoBarra == codigoBarra)
      return true;
    else
      return false;
  }
  // Instanciar objecto ArtigoArmazem e armazenar na lista de artigoArmazem
  void addArtigoArmazem(Map<String, dynamic> data) {
    ArtigoArmazem armazem = new ArtigoArmazem.fromJson(data);
    this.artigoArmazem.add(armazem);
  }

  // Percorrer a lista de artigo e retornar o artigo pretendido
  static Artigo getArtigo(List<Artigo> lstArtigo, String artigo) {
    Artigo _artigo;
    lstArtigo.forEach((element) {
      if (element.artigo == artigo) {
        _artigo = element;
        return;
      }
    });

    return _artigo;
  }

  List<Map<String, dynamic>> listaArmazemToJson() {
    return this.artigoArmazem.map((armazem) {
      return armazem.toJson();
    }).toList();
  }
}
