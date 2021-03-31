import 'dart:convert';
import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  String usuario;
  String nome;
  String senha;
  String documento;
  String perfil;
  String vendedor;
  String vendedorNome;
  String telefone;
  // Usuario({this.usuario});

  Usuario(
      {this.usuario,
      this.nome,
      this.senha,
      this.documento,
      this.perfil,
      this.vendedor,
      this.vendedorNome,
      this.telefone});

  factory Usuario.fromMap(Map<String, dynamic> json) => new Usuario(
        usuario: json['usuario'],
        nome: json['nome'],
        senha: json['senha'],
        documento: json['documento'],
        perfil: json['nivel'],
        vendedor: json['vendedor'],
        vendedorNome: json['vendedorNome'],
        telefone: json['telefone'],
      );

  Map<String, dynamic> toMap() => {
        'usuario': usuario,
        'nome': nome,
        'senha': senha,
        'documento': documento,
        'nivel': perfil,
        'vendedor': vendedor,
        'vendedorNome': vendedorNome,
        'telefone': telefone
      };

  factory Usuario.fromJson(Map<String, dynamic> data) {
    return Usuario(
      usuario: data['usuario'],
      nome: data['nome'],
      senha: data['senha'],
      documento: data['documento'],
      perfil: data['nivel'],
      vendedor: data['vendedor'],
      vendedorNome: data['vendedorNome'],
      telefone: data['telefone'],
    );
  }

  List<Usuario> parseUsuarios(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
  }

  @override
  List<Object> get props => [
        usuario,
        nome,
        senha,
        documento,
        perfil,
        vendedor,
        vendedorNome,
        telefone
      ];

  static Usuario empty() {
    return Usuario(
        usuario: '1',
        nome: '1',
        senha: 'd',
        documento: '2',
        perfil: 'd',
        vendedor: 'd',
        vendedorNome: 'd',
        telefone: 'd');
  }
}
