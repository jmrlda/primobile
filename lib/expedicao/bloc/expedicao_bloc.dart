import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/expedicao/models/models.dart';

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
        }

        if (currentState is ExpedicaoSucesso) {
          yield currentState.expedicao.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ExpedicaoSucesso(
                  expedicao: currentState.expedicao, hasReachedMax: true);
        }

        if (currentState is ExpedicaoSucessoPesquisa) {
          final expedicao = await _fetchExpedicao(0, 20);
          yield ExpedicaoSucesso(expedicao: expedicao, hasReachedMax: true);
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
        }

        if (currentState is ExpedicaoSucesso) {
          final expedicao = expedicaoPesquisar(
              this.query != null ? this.query : 'jmr',
              await _fetchExpedicao(0, 20));
          yield ExpedicaoSucessoPesquisa(
              expedicao: expedicao, hasReachedMax: true, query: this.query);
        }

        if (currentState is ExpedicaoSucessoPesquisa) {
          final expedicao = expedicaoPesquisar(
              this.query != null ? this.query : 'jmr',
              await _fetchExpedicao(0, 20));

          yield expedicao.isEmpty
              ? currentState.copyWith()
              : ExpedicaoSucessoPesquisa(
                  expedicao: expedicao, hasReachedMax: true, query: this.query);
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
          return data.map((expedicao) {
            return Expedicao.fromJson(expedicao);
          }).toList();
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING

          return List<Expedicao>();
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg["Message"]);
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
