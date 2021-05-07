import 'dart:convert';
import 'dart:typed_data';

// import 'package:http/http.dart' as http;
class Fornecedor {
  String fornecedor;
  String nome;

  String nomeFiscal;
  String telefone;
  String numContribuinte;

  Uint8List imagemBuffer;
  String imagemBufferStr;

  Fornecedor(
      {this.fornecedor,
      this.nome,
      this.nomeFiscal,
      this.telefone,
      this.numContribuinte,
      this.imagemBuffer,
      this.imagemBufferStr});

  factory Fornecedor.fromMap(Map<String, dynamic> json) => new Fornecedor(
        fornecedor: json['fornecedor'],
        nome: json['nome'],
        nomeFiscal: json['nome_fiscal'],
        telefone: json['telefone'],
        numContribuinte: json['numContribuinte'],
      );

  Map<String, dynamic> toJson() => {
        'fornecedor': fornecedor,
        'nome': nome,
        'nomeFiscal': nomeFiscal,
        'telefone': telefone,
        'numContribuinte': numContribuinte,
      };

  Map<String, dynamic> imagemToMap() =>
      {'fornecedor': this.fornecedor, 'imagemBuffer': this.imagemBuffer};

  factory Fornecedor.fromJson(Map<String, dynamic> json) {
    return Fornecedor(
      fornecedor: json['fornecedor'],
      nome: json['nome'],
      nomeFiscal: json['nome_fiscal'],
      telefone: json['telefone'],
      numContribuinte: json['numContribuinte'],
      //  imagemBuffer:  data['imagemBuffer'] ,
    );
  }

  static List<Fornecedor> parseFornecedores(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Fornecedor>((json) => Fornecedor.fromJson(json)).toList();
  }

  @override
  String toString() => 'Fornecedor { id: $fornecedor }';
}
