import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/expedicao/models/models.dart';
import 'package:primobile/expedicao/util.dart';

import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';

part 'expedicao_event.dart';
part 'expedicao_state.dart';

class ExpedicaoBloc extends Bloc<ExpedicaoEvent, ExpedicaoState> {
  final http.Client httpClient;
  String query;

  ExpedicaoBloc({this.httpClient, this.query}) : super(ExpedicaoInicial());

  @override
  Stream<ExpedicaoState> mapEventToState(
    ExpedicaoEvent event,
  ) async* {
    final currentState = state;

    if (event is ExpedicaoFetched) {
      try {
        if (currentState is ExpedicaoInicial) {
          List<Expedicao> expedicao = await _fetchExpedicao(0, 20);
          if (expedicao != null && expedicao.length == 0) {
            await SessaoApiProvider.refreshToken();
            expedicao = await _fetchExpedicao(0, 20);
          } else if (expedicao == null) {
            yield ExpedicaoFalha();
            return;
          }

          yield ExpedicaoSucesso(expedicao: expedicao, hasReachedMax: true);
          return;
        } else if (currentState is ExpedicaoSucesso) {
          List<Expedicao> expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));

          yield ExpedicaoSucessoPesquisa(
              query: this.query, expedicao: expedicao, hasReachedMax: true);
          return;
        } else if (currentState is ExpedicaoSucessoPesquisa) {
          final expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));
          yield expedicao.isEmpty
              ? ExpedicaoFalha()
              : ExpedicaoSucessoPesquisa(
                  expedicao: expedicao, hasReachedMax: true, query: this.query);

          return;
        } else if (currentState is ExpedicaoFalha) {
          final expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));
          yield ExpedicaoSucessoPesquisa(
              query: this.query, expedicao: expedicao, hasReachedMax: true);
          return;
        } else {
          yield ExpedicaoFalha();
          return;
        }
      } catch (_) {
        yield ExpedicaoFalha();
      }
    }

    if (event is ExpedicaoSearched) {
      try {
        if (currentState is ExpedicaoInicial) {
          final expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));
          yield ExpedicaoSucessoPesquisa(
              expedicao: expedicao, hasReachedMax: true, query: this.query);

          return;
        } else if (currentState is ExpedicaoSucesso) {
          final expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));
          yield ExpedicaoSucessoPesquisa(
              expedicao: expedicao, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is ExpedicaoSucessoPesquisa) {
          final expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));

          yield expedicao.isEmpty
              ? ExpedicaoFalha()
              : ExpedicaoSucessoPesquisa(
                  expedicao: expedicao, hasReachedMax: true, query: this.query);

          return;
        } else if (currentState is ExpedicaoFalha) {
          final expedicao =
              expedicaoPesquisar(this.query, await _fetchExpedicao(0, 20));

          yield ExpedicaoSucessoPesquisa(
              expedicao: expedicao, hasReachedMax: true, query: this.query);

          return;
        } else {
          yield ExpedicaoFalha();
        }
      } catch (e) {
        yield ExpedicaoFalha();
      }
    }
  }

  bool _hasReachedMax(ExpedicaoState state) =>
      (state is ExpedicaoSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(ExpedicaoState state) =>
      (state is ExpedicaoSucessoPesquisa) && state.hasReachedMax;

  Future<List<Expedicao>> _fetchExpedicao(int startIndex, int limit) async {
    if (listaExpedicao != null && listaExpedicao.length > 0) {
      return listaExpedicao;
    }

    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return List<Expedicao>();
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();

        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/Plataforma/Listas/CarregaLista/inv_cabecexpedicoes',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          final List data = json.decode(response.body)["Data"] as List;
          listaExpedicao = data.map((expedicao) {
            return Expedicao.fromJson(expedicao);
          }).toList();

          return listaExpedicao;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING
          listaExpedicao = List<Expedicao>();

          return listaExpedicao;
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg);
        }
      }
    } catch (e) {
      throw e;
    }

    // } else {
    //   throw Exception('Erro na busca por artigos');
    // }
  }
}
