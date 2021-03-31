import 'dart:convert';

class Rececao {
  int rececao;
  String data;
  // List<ArtigoExpedicao> listaArtigo;
  String listaArtigo;
  String usuario;

  Rececao({this.rececao, this.data, this.listaArtigo, this.usuario});

  factory Rececao.fromMap(Map<String, dynamic> json) => new Rececao(
        rececao: json['rececao'],
        data: json['data'],
        listaArtigo: json['listaArtigo'],
        usuario: json['usuario'],
      );

  Map<String, dynamic> toMap() => {
        'rececao': rececao,
        'data': data,
        'listaArtigo': listaArtigo,
        'usuario': usuario,
      };

  factory Rececao.fromJson(Map<String, dynamic> json) {
    // String numContrib = json['numContrib'] == "" ? "0" : data['numContrib'];
    // numContrib = numContrib.replaceAll(" ", "");
    return Rececao(
      rececao: json['rececao'],
      data: json['data'],
      listaArtigo: json['listaArtigo'],
      usuario: json['usuario'],
    );
    // data['imagemBuffer'] == null ? null : data['imagemBuffer']);
  }

  List<Rececao> parseRececao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Rececao>((json) => Rececao.fromJson(json)).toList();
  }
}
