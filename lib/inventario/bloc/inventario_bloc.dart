import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/inventario/models/models.dart';

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
          InventarioFalha();
        }
      } catch (e) {
        yield InventarioFalha();
      }
    }
  }

  bool _hasReachedMax(InventarioState state) =>
      (state is InventarioSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(InventarioState state) =>
      (state is InventarioSucessoPesquisa) && state.hasReachedMax;

  Future<List<Inventario>> _fetchInventario(int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      List<Inventario> listaInventario = List<Inventario>();
      dynamic data = await getCacheData("inventario");

      if (data != null) {
        data = json.decode(data);
        // listaCliente.clear();
        if (data.length > 0) {
          for (dynamic rawInventario in data) {
            listaInventario.add(Inventario.fromJson(rawInventario));
          }

          return listaInventario;
        }
      }
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

          for (dynamic rawArtigo in data) {
            listaInventario.add(Inventario.fromJson(rawArtigo));
          }
          await saveCacheData("inventario", listaInventario);

          return listaInventario;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING
          listaInventario = List<Inventario>();

          return listaInventario;
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg["Message"]);
          return null;
        }
      }
    } catch (e) {
      if (e.osError.errorCode == 111) {
        // return 2;
        print("sem internet ");
      }

      // return 3;
    }

    // } else {
    //   throw Exception('Erro na busca por artigos');
    // }
  }
}
