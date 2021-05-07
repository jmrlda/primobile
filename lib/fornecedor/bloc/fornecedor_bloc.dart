import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/fornecedor/models/models.dart';

import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';

part 'fornecedor_event.dart';
part 'fornecedor_state.dart';

class FornecedorBloc extends Bloc<FornecedorEvent, FornecedorState> {
  final http.Client httpClient;
  String query;

  FornecedorBloc({this.httpClient, this.query}) : super(FornecedorInicial());

  @override
  Stream<FornecedorState> mapEventToState(
    FornecedorEvent event,
  ) async* {
    final currentState = state;

    if (event is FornecedorFetched) {
      try {
        if (currentState is FornecedorInicial) {
          List<Fornecedor> fornecedores = await _fetchFornecedores(0, 20);
          if (fornecedores != null) {
            await SessaoApiProvider.refreshToken();
            fornecedores = await _fetchFornecedores(0, 20);
          }
          if (fornecedores == null) {
            yield FornecedorFalha();
            return;
          }

          yield FornecedorSucesso(
              fornecedores: fornecedores, hasReachedMax: true);
          return;
        } else if (currentState is FornecedorSucesso) {
          List<Fornecedor> fornecedores = await _fetchFornecedores(0, 20);

          yield FornecedorSucesso(
              fornecedores: fornecedores, hasReachedMax: true);
          return;
        } else if (currentState is FornecedorSucessoPesquisa) {
          final fornecedores = await _fetchFornecedores(0, 20);
          yield fornecedores.isEmpty
              ? FornecedorFalha()
              : FornecedorSucesso(
                  fornecedores: fornecedores, hasReachedMax: true);
          return;
        }
      } catch (_) {
        yield FornecedorFalha();
      }
    }

    if (event is FornecedorSearched) {
      try {
        if (currentState is FornecedorInicial) {
          final fornecedores =
              fornecedorPesquisar(this.query, await _fetchFornecedores(0, 20));
          yield FornecedorSucessoPesquisa(
              fornecedores: fornecedores,
              hasReachedMax: true,
              query: this.query);

          return;
        } else if (currentState is FornecedorSucesso) {
          final fornecedores =
              fornecedorPesquisar(this.query, await _fetchFornecedores(0, 20));
          yield FornecedorSucessoPesquisa(
              fornecedores: fornecedores,
              hasReachedMax: true,
              query: this.query);
          return;
        } else if (currentState is FornecedorSucessoPesquisa) {
          final fornecedores =
              fornecedorPesquisar(this.query, await _fetchFornecedores(0, 20));

          yield fornecedores.isEmpty
              ? FornecedorFalha()
              : FornecedorSucessoPesquisa(
                  fornecedores: fornecedores,
                  hasReachedMax: true,
                  query: this.query);

          return;
        } else if (currentState is FornecedorFalha) {
          final fornecedores =
              fornecedorPesquisar(this.query, await _fetchFornecedores(0, 20));

          FornecedorSucessoPesquisa(
              fornecedores: fornecedores,
              hasReachedMax: true,
              query: this.query);
          return;
        } else {
          yield FornecedorFalha();
        }
      } catch (e) {
        yield FornecedorFalha();
      }
    }
  }

  bool _hasReachedMax(FornecedorState state) =>
      (state is FornecedorSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(FornecedorState state) =>
      (state is FornecedorSucessoPesquisa) && state.hasReachedMax;

  Future<List<Fornecedor>> _fetchFornecedores(int startIndex, int limit) async {
    try {
      dynamic data = await getCacheData("fornecedor");
      List<Fornecedor> listaFornecedor = List<Fornecedor>();
      if (data != null) {
        data = json.decode(data);

        // listaFornecedor.clear();
        if (data.length > 0) {
          for (dynamic rawFornecedor in data) {
            listaFornecedor.add(Fornecedor.fromJson(rawFornecedor));
          }
          return listaFornecedor;
        }
      }

      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return List<Fornecedor>();
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();
        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/Plataforma/Listas/CarregaLista/fornecedores',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          final List data = json.decode(response.body)["Data"] as List;
          for (dynamic rawFornecedor in data) {
            listaFornecedor.add(Fornecedor.fromJson(rawFornecedor));
          }
          // data.map((cliente) {
          //   listaFornecedor.add(Fornecedor.fromJson(cliente));
          // });
          await saveCacheData("fornecedor", listaFornecedor);

          return listaFornecedor;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING

          return List<Fornecedor>();
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
