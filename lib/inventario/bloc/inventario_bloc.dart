import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/inventario/util.dart';

import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';

part 'inventario_event.dart';
part 'inventario_state.dart';

class InventarioBloc extends Bloc<InventarioEvent, InventarioState> {
  final http.Client httpClient;
  String query;

  InventarioBloc({this.httpClient, this.query}) : super(InventarioInicial());

  @override
  Stream<InventarioState> mapEventToState(
    InventarioEvent event,
  ) async* {
    final currentState = state;

    if (event is InventarioFetched) {
      try {
        if (currentState is InventarioInicial) {
          List<Inventario> inventario = await _fetchInventario(0, 20);

          if (inventario != null && inventario.length == 0) {
            await SessaoApiProvider.refreshToken();
            inventario = await _fetchInventario(0, 20);
          } else if (inventario == null) {
            yield InventarioFalha();
            return;
          }

          yield InventarioSucesso(inventario: inventario, hasReachedMax: true);
          return;
        }

        if (currentState is InventarioSucesso) {
          yield currentState.inventario.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : InventarioSucesso(
                  inventario: currentState.inventario, hasReachedMax: true);
        }

        if (currentState is InventarioSucessoPesquisa) {
          final inventario = await _fetchInventario(0, 20);
          yield InventarioSucesso(inventario: inventario, hasReachedMax: true);
          return;
        }
      } catch (_) {
        yield InventarioFalha();
        return;
      }
    }

    if (event is InventarioSearched) {
      try {
        if (currentState is InventarioInicial) {
          final inventario =
              inventarioPesquisar(this.query, await _fetchInventario(0, 20));
          yield InventarioSucessoPesquisa(
              inventario: inventario, hasReachedMax: true, query: this.query);

          return;
        }

        if (currentState is InventarioSucesso) {
          final inventario =
              inventarioPesquisar(this.query, await _fetchInventario(0, 20));
          // yield InventarioSucessoPesquisa(
          //     inventario: inventario, hasReachedMax: true, query: this.query);
          // return;

          yield InventarioSucessoPesquisa(
              inventario: inventario, hasReachedMax: true, query: this.query);
          return;
        }

        if (currentState is InventarioSucessoPesquisa) {
          final inventario =
              inventarioPesquisar(this.query, await _fetchInventario(0, 20));

          yield inventario.isEmpty
              ? InventarioFalha()
              : InventarioSucessoPesquisa(
                  inventario: inventario,
                  hasReachedMax: true,
                  query: this.query);
        } else if (currentState is InventarioFalha) {
          final inventario =
              inventarioPesquisar(this.query, await _fetchInventario(0, 20));
          yield inventario.isEmpty
              ? InventarioFalha()
              : InventarioSucessoPesquisa(
                  inventario: inventario,
                  hasReachedMax: true,
                  query: this.query);
          return;
        } else {
          yield InventarioFalha();
          return;
        }
      } catch (e) {
        yield InventarioFalha();
        return;
      }
    }
  }

  bool _hasReachedMax(InventarioState state) =>
      (state is InventarioSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(InventarioState state) =>
      (state is InventarioSucessoPesquisa) && state.hasReachedMax;

  Future<List<Inventario>> _fetchInventario(int startIndex, int limit) async {
    try {
      if (listaInventarioDisplay.length > 0) {
        return listaInventarioDisplay;
      } else {
        dynamic data = await getCacheData("inventario");

        if (data != null) {
          data = json.decode(data);
          // listaCliente.clear();
          if (data.length > 0) {
            for (dynamic rawInventario in data) {
              listaInventarioDisplay.add(Inventario.fromJson(rawInventario));
            }

            return listaInventarioDisplay;
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

      // return 3;
    }

    // } else {
    //   throw Exception('Erro na busca por artigos');
    // }
  }

  Future<List<Inventario>> inventarioSync() async {
    try {
      listaInventarioDisplay.clear();
      listaInventarioDisplayFiltro.clear();
      listaInventarioSelecionado.clear();
      removeKeyCacheData("inventario");

      List<Inventario> inventario = await _fetch();

      if (inventario != null && inventario.length == 0) {
        await SessaoApiProvider.refreshToken();
        inventario = await _fetch();
      }
      return inventario;
    } catch (e) {
      return null;
    }
  }

  Future<List<Inventario>> _fetch() async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessão não existe');
        return List<Inventario>();
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();
        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/InventarioStockController/Inventario/lista',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          // final List data = json.decode(response.body)["Data"] as List;
          dynamic data = json.decode(response.body);
          data = json.decode(data)["DataSet"]["Table"];
          ToList lista = new ToList();

          for (dynamic rawArtigo in data) {
            Inventario _inventario = Inventario.fromJson(rawArtigo);
            listaInventarioDisplay.add(_inventario);
            lista.items.add(_inventario);
          }
          await saveCacheData("inventario", lista);

          return listaInventarioDisplay;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING
          return List<Inventario>();
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
