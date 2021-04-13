import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:primobile/sessao/empresaFilial_modelo.dart';
import 'package:primobile/usuario/models/models.dart';

class SessaoApiProvider {
  static String base_url = '192.168.0.104:2018';
  static String protocolo = 'http://';

  /// @login  - Metodo para controlo de entrada e sessão dos usuarios

  /// @Retorno : inteiro

  ///            0 - sucesso

  ///            1 - falha na autenticação

  ///            2 - falha de acesso a internet
  ///            3 - Erro desconhecido
  ///   ///            4 - Ficheiro de configuração não encontrado

  ///            TODO:
  ///             instancia desconhecida
  ///             empresa desconhecida
  ///             line nao encontrada
  ///             grant_type nao suportado
  ///

  static Future<Map<String, dynamic>> login(
      String nome_email, String senha, bool online) async {
    Map<String, dynamic> rv = Map<String, dynamic>();
    rv = {'status': -1, 'descricao': ""};

    var login_url = '/WebApi/token';
    nome_email = nome_email.trim();
    try {
      var sessao = await read();

      if (sessao != null && sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return rv = {
          'status': 4,
          'descricao': "Ficheiro de configuração não encontrado"
        };
      }

      var response;
      if (online == true) {
        response = await http.post(
            protocolo + sessao["ip_local"] + ":" + sessao["porta"] + login_url,
            body: {
              "username": nome_email,
              "password": senha,
              "company": sessao['company'],
              "grant_type": sessao['grant_type'],
              "line": sessao['line'],
              "instance": sessao['instance']
            });

        rv['status'] = 0;
        rv['descricao'] = "login sucesso";
      } else {
        if (sessao == null || sessao.length == 0) {
          rv['status'] = 1;
          rv['descricao'] = "Sem arquivo da sessão";
        } else {
          if (sessao["nome"].toString().toLowerCase() ==
                  nome_email.toLowerCase() &&
              sessao["senha"] == senha) {
            rv['status'] = 0;
            rv['descricao'] = "login da sessão sucesso";
          }
        }
      }

      Map<String, dynamic> parsed = Map<String, dynamic>();
      if (response != null) {
        parsed = jsonDecode(response.body);
        if (response.statusCode == 200) {
          sessao['access_token'] = parsed['access_token'];
          sessao['token_type'] = parsed['token_type'];
          sessao['expires_in'] = parsed['expires_in'];
          _save(jsonEncode(sessao));

          // _save(jsonEncode({
          //   "nome": nome_email,
          //   "senha": senha,
          //   "access_token": parsed['access_token'],
          //   "token_type": parsed['token_type'],
          //   "expires_in": parsed['expires_in'],
          //   "company": "DEMO",
          //   "grant_type": "password",
          //   "line": "professional",
          //   "instance": "default"
          // }));
          // sessao = await read();
          rv['status'] = 0;
          rv['descricao'] = "login sucesso";
        } else {
          rv['status'] = 1;
          rv['descricao'] = parsed['error'];
        }
      }
    } catch (e) {
      // if (e.osError.errorCode == 111) {
      //   rv =  2;
      // }

      rv['status'] = 3;
      rv['descricao'] = e;
    }

    return rv;
  }

  // ler dados da sessao armazenado em um ficheiro
  // e retornar o seu conteudo
  static Future<Map<String, dynamic>> read() async {
    Map<String, dynamic> parsed = Map<String, dynamic>();

    try {
      final directorio = await getApplicationDocumentsDirectory();
      final file = File('${directorio.path}/sessao.json');
      if (file.existsSync() == true) {
        String text = await file.readAsString();
        parsed = jsonDecode(text);
      } else {
        print('[sessao read] Atenção Ficheiro não existe!');

        parsed = null;
      }
    } catch (e) {
      // print('nao foi possivel ler o ficheiro');
      // return null;
      parsed = null;

      throw e;
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> readConfig() async {
    Map<String, dynamic> parsed = Map<String, dynamic>();

    try {
      final directorio = await getApplicationDocumentsDirectory();
      final file = File('${directorio.path}/sessao.json');
      if (file.existsSync() == true) {
        String text = await file.readAsString();
        parsed = jsonDecode(text);
      } else {
        print('[sessao read] Atenção Ficheiro não existe!');

        return Map();
      }
    } catch (e) {
      print('nao foi possivel ler o ficheiro');
      return Map();
    }

    return parsed;
  }

  ///  Salvar dados da sessao em um ficheiro para seu uso posterior

  static _save(String data) async {
    final directorio = await getApplicationDocumentsDirectory();
    final file = File('${directorio.path}/sessao.json');
    await file.writeAsString(data);
  }

  // ignore: slash_for_doc_comments
  /**
   *
   * @Retorno : inteiro
   *            0 - sucesso
   *            1 - falha autenticacao
   *            2 - falha acesso internet
   *            3 - Erro desconhecido
   *
   */
  static Future<int> alterarSenha(
      String senha_actual, String senha_nova, String senha_confirmar) async {
    var novasenha_url = '/usuarios/alterarsenha';

    try {
      var sessao = await read();
      var response;
      String nome_email = sessao["nome"].toString();
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
      } else {
        response = await http.post(base_url + novasenha_url, body: {
          "nome": nome_email,
          "senha_actual": senha_actual,
          "senha_nova": senha_nova,
          "senha_confirmar": senha_confirmar
        });
      }
      Map<String, dynamic> parsed = Map<String, dynamic>();
      parsed = jsonDecode(response.body);
      if (parsed['resultado'] == null) {
        return 1;
      }
    } catch (e) {
      if (e.osError.errorCode == 111) {
        return 2;
      }

      return 3;
    }

    return 0;
  }

  static Future<Map<String, dynamic>> conectar(
      Usuario usuario, Filial config) async {
    Map<String, dynamic> rv = Map<String, dynamic>();
    rv = {'status': -1, 'descricao': ""};

    var login_url = '/WebApi/token';
    try {
      // var sessao = await read();
      var response;
      response = await http.post(
          protocolo + config.ipLocal + ":" + config.porta + login_url,
          body: {
            "username": usuario.nome,
            "password": usuario.senha,
            "company": config.company,
            "grant_type": config.grantType,
            "line": config.line,
            "instance": config.instance
          });

      rv['status'] = 0;
      rv['descricao'] = "conectado com sucesso";

      // else {
      //   if (sessao == null || sessao.length == 0) {
      //     rv['status'] = 1;
      //     rv['descricao'] = "Sem arquivo da sessão";
      //   } else {
      //     if (sessao["nome"].toString().toLowerCase() ==
      //             nome_email.toLowerCase() &&
      //         sessao["senha"] == senha) {
      //       rv['status'] = 0;
      //       rv['descricao'] = "login da sessão sucesso";
      //     }
      //   }
      // }

      Map<String, dynamic> parsed = Map<String, dynamic>();
      if (response != null) {
        if (response.statusCode == 200) {
          parsed = jsonDecode(response.body);

          _save(jsonEncode({
            "nome": usuario.nome,
            "senha": usuario.senha,
            "access_token": parsed['access_token'],
            "token_type": parsed['token_type'],
            "expires_in": parsed['expires_in'],
            "company": config.company,
            "grant_type": config.grantType,
            "line": config.line,
            "instance": config.instance,
            "nome_empresa": config.nome,
            "porta": config.porta,
            "ip_local": config.ipLocal,
            "ip_global": config.ipGlobal,
          }));
          // sessao = await read();
          rv['status'] = 0;
          rv['descricao'] = "conectado com sucesso";
        } else {
          rv['status'] = 1;
          rv['descricao'] = parsed['error'];
        }
      }
    } catch (e) {
      // if (e.osError.errorCode == 111) {
      //   rv =  2;
      // }

      rv['status'] = 3;
      rv['descricao'] = e;
    }

    return rv;
  }
}
