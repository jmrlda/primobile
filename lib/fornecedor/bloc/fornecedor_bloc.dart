import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/fornecedor/models/models.dart';
import 'package:primobile/fornecedor/util.dart';

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

          yield FornecedorSucessoPesquisa(
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
      if (fornecedorListaDisplay.length > 0) {
        return fornecedorListaDisplay;
      } else {
        dynamic data = await getCacheData("fornecedor");
        if (data != null) {
          data = json.decode(data);

          // listaFornecedor.clear();
          if (data.length > 0) {
            for (dynamic rawFornecedor in data) {
              fornecedorListaDisplay.add(Fornecedor.fromJson(rawFornecedor));
            }
            return fornecedorListaDisplay;
          }
        }
        return await _fetch();
      }
    } catch (e) {
      try {
        return await _fetch();
      } catch (e) {
        return null;
      }
    }
  }

  Future<List<Fornecedor>> fornecedorSync() async {
    try {
      fornecedorListaDisplay.clear();
      fornecedorLista.clear();
      fornecedorListaSelecionado.clear();
      removeKeyCacheData("fornecedor");

      List<Fornecedor> fornecedores = await _fetch();
      if (fornecedores != null) {
        await SessaoApiProvider.refreshToken();
        fornecedores = await _fetch();
      }

      return fornecedores;
    } catch (e) {
      return null;
    }
  }

  Future<List<Fornecedor>> _fetch() async {
    try {
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
                '/WebApi/FornecedorController/fornecedor/lista',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          dynamic data = json.decode(response.body);
          data = json.decode(data)["DataSet"]["Table"];

          ToList lista = new ToList();

          for (dynamic rawFornecedor in data) {
            Fornecedor _fornecedor = Fornecedor.fromJson(rawFornecedor);
            fornecedorListaDisplay.add(_fornecedor);
            lista.items.add(_fornecedor);
          }
          // data.map((cliente) {
          //   listaFornecedor.add(Fornecedor.fromJson(cliente));
          // });
          await saveCacheData("fornecedor", lista);

          return fornecedorListaDisplay;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING

          return List<Fornecedor>();
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg["Message"]);
          return null;
        }
      }
    } catch (e) {
      throw e;
    }
  }
}
