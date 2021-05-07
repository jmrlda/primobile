import 'dart:convert';

import 'package:primobile/usuario/models/models.dart';

import 'empresaFilial_modelo.dart';

class Sessao {
  Usuario usuario;
  Filial filial;

  Sessao({this.usuario, this.filial});

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'filial': filial,
      };

  factory Sessao.fromJson(Map<String, dynamic> data) {
    return Sessao(
      usuario: data['usuario'],
      filial: data['filial'],
    );
  }

  List<Sessao> parseSessao(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Sessao>((json) => Sessao.fromJson(json)).toList();
  }
}
