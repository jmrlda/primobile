import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import 'package:primobile/cliente/models/models.dart';
import 'package:primobile/cliente/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';

part 'cliente_event.dart';
part 'cliente_state.dart';

class ClienteBloc extends Bloc<ClienteEvent, ClienteState> {
  final http.Client httpClient;
  String query;

  ClienteBloc({this.httpClient, this.query}) : super(ClienteInicial());

  @override
  Stream<ClienteState> mapEventToState(
    ClienteEvent event,
  ) async* {
    final currentState = state;

    if (event is ClienteFetched) {
      try {
        if (currentState is ClienteInicial) {
          List<Cliente> clientes = await _fetchClientes(0, 20);
          if (clientes != null && clientes.length == 0) {
            await SessaoApiProvider.refreshToken();
            clientes = await _fetchClientes(0, 20);
          } else if (clientes == null) {
            yield ClienteFalha();
            return;
          }

          yield ClienteSucesso(clientes: clientes, hasReachedMax: true);
          return;
        }

        if (currentState is ClienteSucesso) {
          yield currentState.clientes.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ClienteSucesso(
                  clientes: currentState.clientes, hasReachedMax: true);
        }

        if (currentState is ClienteSucessoPesquisa) {
          final clientes = await _fetchClientes(0, 20);
          yield ClienteSucesso(clientes: clientes, hasReachedMax: true);
          return;
        }
      } catch (_) {
        yield ClienteFalha();
      }
    }

    if (event is ClienteSearched) {
      try {
        if (currentState is ClienteInicial) {
          final clientes =
              clientePesquisar(this.query, await _fetchClientes(0, 20));
          yield ClienteSucessoPesquisa(
              clientes: clientes, hasReachedMax: true, query: this.query);

          return;
        }

        if (currentState is ClienteSucesso) {
          final clientes = clientePesquisar(
              this.query != null ? this.query : 'jmr',
              await _fetchClientes(0, 20));
          yield ClienteSucessoPesquisa(
              clientes: clientes, hasReachedMax: true, query: this.query);
        }

        if (currentState is ClienteSucessoPesquisa) {
          final clientes = clientePesquisar(
              this.query != null ? this.query : 'jmr',
              await _fetchClientes(0, 20));

          yield clientes.isEmpty
              ? currentState.copyWith()
              : ClienteSucessoPesquisa(
                  clientes: clientes, hasReachedMax: true, query: this.query);
        }
      } catch (e) {
        yield ClienteFalha();
      }
    }
  }

  bool _hasReachedMax(ClienteState state) =>
      (state is ClienteSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(ClienteState state) =>
      (state is ClienteSucessoPesquisa) && state.hasReachedMax;

  Future<List<Cliente>> _fetchClientes(int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return List<Cliente>();
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();
        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/Plataforma/Listas/CarregaLista/clientes',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          final List data = json.decode(response.body)["Data"] as List;
          return data.map((cliente) {
            return Cliente.fromJson(cliente);
          }).toList();
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING

          return List<Cliente>();
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
