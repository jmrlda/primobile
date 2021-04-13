import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
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
          final inventario = await _fetchInventario(0, 20);
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
          final inventario = inventarioPesquisar(
              this.query != null ? this.query : 'jmr',
              await _fetchInventario(0, 20));
          yield InventarioSucessoPesquisa(
              inventario: inventario, hasReachedMax: true, query: this.query);
        }

        if (currentState is InventarioSucessoPesquisa) {
          final inventario = inventarioPesquisar(
              this.query != null ? this.query : 'jmr',
              await _fetchInventario(0, 20));

          yield inventario.isEmpty
              ? currentState.copyWith()
              : InventarioSucessoPesquisa(
                  inventario: inventario,
                  hasReachedMax: true,
                  query: this.query);
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
      var sessao = await SessaoApiProvider.read();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessão não existe');
        return List<Inventario>();
      } else {
        String token = sessao['access_token'];
        final response = await httpClient.get(
            'http://192.168.0.104:2018/WebApi/InventarioStockController/Inventario/lista',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          final List data = json.decode(response.body)["Data"] as List;
          return data.map((inventario) {
            return Inventario.fromJson(inventario);
          }).toList();
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg["Message"]);
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
