import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import 'package:primobile/cliente/models/models.dart';
import 'package:primobile/cliente/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';

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
          // if (clientes != null) {
          //   await SessaoApiProvider.refreshToken();
          //   clientes = await _fetchClientes(0, 20);
          // }
          if (clientes == null) {
            yield ClienteFalha();
            return;
          }

          yield ClienteSucesso(clientes: clientes, hasReachedMax: true);
          return;
        } else if (currentState is ClienteSucesso) {
          List<Cliente> clientes = await _fetchClientes(0, 20);

          yield ClienteSucesso(clientes: clientes, hasReachedMax: true);
          return;
        } else if (currentState is ClienteSucessoPesquisa) {
          final clientes = await _fetchClientes(0, 20);
          yield clientes.isEmpty
              ? ClienteFalha()
              : ClienteSucesso(clientes: clientes, hasReachedMax: true);
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
        } else if (currentState is ClienteSucesso) {
          final clientes =
              clientePesquisar(this.query, await _fetchClientes(0, 20));
          yield ClienteSucessoPesquisa(
              clientes: clientes, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is ClienteSucessoPesquisa) {
          final clientes =
              clientePesquisar(this.query, await _fetchClientes(0, 20));

          yield clientes.isEmpty
              ? ClienteFalha()
              : ClienteSucessoPesquisa(
                  clientes: clientes, hasReachedMax: true, query: this.query);

          return;
        } else if (currentState is ClienteFalha) {
          final clientes =
              clientePesquisar(this.query, await _fetchClientes(0, 20));
          yield clientes.isEmpty
              ? ClienteFalha()
              : ClienteSucessoPesquisa(
                  clientes: clientes, hasReachedMax: true, query: this.query);
          // ClienteSucessoPesquisa(
          //     clientes: clientes, hasReachedMax: true, query: this.query);
          return;
        } else {
          yield ClienteFalha();
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
      if (clienteListaDisplay.length > 0) {
        return clienteListaDisplay;
      } else {
        dynamic data = await getCacheData("cliente");
        if (data != null) {
          data = json.decode(data);

          if (data.length > 0) {
            clienteListaDisplay.clear();

            for (dynamic rawCliente in data) {
              clienteListaDisplay.add(Cliente.fromJson(rawCliente));
            }
            return clienteListaDisplay;
          }

          return List<Cliente>();
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

  Future<List<Cliente>> clienteSync() async {
    try {
      clienteListaDisplay.clear();
      clienteListaSelecionado.clear();

      removeKeyCacheData("cliente");
      List<Cliente> clientes = await _fetch();
      if (clientes == null) {
        await SessaoApiProvider.refreshToken();
        clientes = await _fetch();
      }

      return clientes;
    } catch (e) {
      return null;
    }
  }

  Future<List<Cliente>> _fetch() async {
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
            protocolo + baseUrl + '/WebApi/ClienteController/Cliente/lista',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          // final List data = json.decode(response.body)["Data"] as List;
          dynamic data = json.decode(response.body);
          data = json.decode(data)["DataSet"]["Table"];

          ToList lista = new ToList();
          clienteListaDisplay.clear();
          for (dynamic rawCliente in data) {
            Cliente _cliente = Cliente.fromJson(rawCliente);

            clienteListaDisplay.add(_cliente);
            lista.items.add(_cliente);
          }
          // data.map((cliente) {
          //   listaCliente.add(Cliente.fromJson(cliente));
          // });
          await saveCacheData("cliente", lista);

          return clienteListaDisplay;
        } else if (response.statusCode == 401) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING
          await SessaoApiProvider.refreshToken();
          return await _fetch();
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
