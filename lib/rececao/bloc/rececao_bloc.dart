import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/rececao/models/models.dart';

import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';

part 'rececao_event.dart';
part 'rececao_state.dart';

class RececaoBloc extends Bloc<RececaoEvent, RececaoState> {
  final http.Client httpClient;
  String query;

  RececaoBloc({this.httpClient, this.query}) : super(RececaoInicial());

  @override
  Stream<RececaoState> mapEventToState(
    RececaoEvent event,
  ) async* {
    final currentState = state;

    if (event is RececaoFetched) {
      try {
        if (currentState is RececaoInicial) {
          List<Rececao> rececao = await _fetchRececao(0, 20);

          if (rececao != null && rececao.length == 0) {
            await SessaoApiProvider.refreshToken();
            rececao = await _fetchRececao(0, 20);
          } else if (rececao == null) {
            yield RececaoFalha();
            return;
          }
          yield RececaoSucesso(rececao: rececao, hasReachedMax: true);
          return;
        } else if (currentState is RececaoSucesso) {
          List<Rececao> rececao = await _fetchRececao(0, 20);
          yield currentState.rececao.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : RececaoSucesso(rececao: rececao, hasReachedMax: true);
        } else if (currentState is RececaoSucessoPesquisa) {
          final rececao = await _fetchRececao(0, 20);
          yield RececaoSucesso(rececao: rececao, hasReachedMax: true);
          return;
        } else {
          yield RececaoFalha();
          return;
        }
      } catch (_) {
        yield RececaoFalha();
      }
    }

    if (event is RececaoSearched) {
      try {
        if (currentState is RececaoInicial) {
          final rececao =
              rececaoPesquisar(this.query, await _fetchRececao(0, 20));
          yield RececaoSucessoPesquisa(
              rececao: rececao, hasReachedMax: true, query: this.query);

          return;
        } else if (currentState is RececaoSucesso) {
          final rececao =
              rececaoPesquisar(this.query, await _fetchRececao(0, 20));
          yield RececaoSucessoPesquisa(
              rececao: rececao, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is RececaoSucessoPesquisa) {
          final rececao =
              rececaoPesquisar(this.query, await _fetchRececao(0, 20));

          yield rececao.isEmpty
              ? RececaoFalha()
              : RececaoSucessoPesquisa(
                  rececao: rececao, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is RececaoFalha) {
          final rececao =
              rececaoPesquisar(this.query, await _fetchRececao(0, 20));
          yield RececaoSucessoPesquisa(
              rececao: rececao, hasReachedMax: true, query: this.query);
          return;
        } else {
          yield RececaoFalha();
        }
      } catch (e) {
        yield RececaoFalha();
      }
    }
  }

  bool _hasReachedMax(RececaoState state) =>
      (state is RececaoSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(RececaoState state) =>
      (state is RececaoSucessoPesquisa) && state.hasReachedMax;

  Future<List<Rececao>> _fetchRececao(int startIndex, int limit) async {
    List<Rececao> listaRececao = List<Rececao>();

    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      dynamic data = await getCacheData("rececao");

      if (data != null) {
        data = json.decode(data);
        // listaCliente.clear();
        if (data.length > 0) {
          for (dynamic rawRececao in data) {
            listaRececao.add(Rececao.fromJson(rawRececao));
          }

          return listaRececao;
        }
      }

      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return List<Rececao>();
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();

        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/Plataforma/Listas/CarregaLista/inv_cabecrececoes',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          final List data = json.decode(response.body)["Data"] as List;
          // data.map((rececao) {
          //   listaRececao.add(Rececao.fromJson(rececao));
          // });

          for (dynamic rececao in data) {
            listaRececao.add(Rececao.fromJson(rececao));
          }

          await saveCacheData("rececao", listaRececao);

          return listaRececao;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING
          return List<Rececao>();
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg["Message"]);
        }
      }
    } catch (e) {
      throw e;
    }
  }
}
