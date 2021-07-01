import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// local
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:primobile/util/util.dart';

part 'artigo_event.dart';
part 'artigo_state.dart';

class ArtigoBloc extends Bloc<ArtigoEvent, ArtigoState> {
  final http.Client httpClient;
  String query;
  ArtigoBloc({@required this.httpClient, this.query}) : super(ArtigoInicial());

  @override
  Stream<ArtigoState> mapEventToState(
    ArtigoEvent event,
  ) async* {
    final currentState = state;

    if (event is ArtigoFetched) {
      try {
        if (currentState is ArtigoInicial) {
          List<Artigo> artigos = await _fetchArtigos(0, 20);

          if (artigos != null && artigos.length == 0) {
            await SessaoApiProvider.refreshToken();
            artigos = await _fetchArtigos(0, 20);
          } else if (artigos == null) {
            yield ArtigoFalha();
            return;
          }

          yield ArtigoSucesso(artigos: artigos, hasReachedMax: true);
          return;
        } else if (currentState is ArtigoSucesso) {
          final artigos = await _fetchArtigos(currentState.artigos.length, 20);
          yield currentState.artigos.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ArtigoSucesso(artigos: artigos, hasReachedMax: true);
        } else if (currentState is ArtigoSucessoPesquisa) {
          final artigos = await _fetchArtigos(0, 20);
          yield ArtigoSucesso(artigos: artigos, hasReachedMax: true);
          return;
        } else {
          yield ArtigoFalha();
          return;
        }
      } catch (_) {
        yield ArtigoFalha();
      }
    }

    if (event is ArtigoSearched) {
      try {
        if (currentState is ArtigoInicial) {
          final artigos =
              artigoPesquisar(this.query, await _fetchArtigos(0, 20));
          yield ArtigoSucessoPesquisa(
              artigos: artigos, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is ArtigoSucesso) {
          final artigos =
              artigoPesquisar(this.query, await _fetchArtigos(0, 20));
          yield ArtigoSucessoPesquisa(
              artigos: artigos, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is ArtigoSucessoPesquisa) {
          final artigos =
              artigoPesquisar(this.query, await _fetchArtigos(0, 20));
          yield artigos.isEmpty
              ? ArtigoFalha()
              : ArtigoSucessoPesquisa(
                  artigos: artigos, hasReachedMax: true, query: this.query);
          // yield ArtigoSucessoPesquisa(
          //     artigos: artigos, hasReachedMax: true, query: this.query);
          return;
        } else if (currentState is ArtigoFalha) {
          final artigos =
              artigoPesquisar(this.query, await _fetchArtigos(0, 20));

          yield ArtigoSucessoPesquisa(
              artigos: artigos, hasReachedMax: true, query: this.query);
          return;
        } else {
          yield ArtigoFalha();
        }
      } catch (_) {
        yield ArtigoFalha();
      }
    }
  }

  bool _hasReachedMax(ArtigoState state) =>
      (state is ArtigoSucesso) && state.hasReachedMax;

  bool _pesquisaHasReachedMax(ArtigoState state) =>
      (state is ArtigoSucessoPesquisa) && state.hasReachedMax;

  Future<List<Artigo>> _fetchArtigos(int startIndex, int limit,
      {bool isSync = false}) async {
    try {
      if (isSync == true) {
        artigoListaDisplay.clear();
        artigoListaArmazemDisplay.clear();
        artigoListaDisplayFiltro.clear();
        removeKeyCacheData("artigo");
      } else {
        if (artigoListaDisplayFiltro.length > 0) {
          return artigoListaDisplayFiltro;
        } else {
          dynamic data = json.decode(await getCacheData("artigo"));
          if (data != null) {
            if (data.length > 0) {
              for (dynamic rawArtigo in data) {
                artigoListaDisplayFiltro.add(Artigo.fromJson(rawArtigo));
              }
              return artigoListaDisplayFiltro;
            }
          }
        }
      }
      return await _fetch();
    } catch (e) {
      return await _fetch();
    }

    // } else {
    //   throw Exception('Erro na busca por artigos');
    // }
  }

  Future<List<Artigo>> syncArtigo() async {
    try {
      artigoListaDisplay.clear();
      artigoListaArmazemDisplay.clear();
      artigoListaDisplayFiltro.clear();
      removeKeyCacheData("artigo");
      List<Artigo> artigos = await _fetch();
      if (artigos != null && artigos.length == 0) {
        await SessaoApiProvider.refreshToken();
        artigos = await _fetch();
      }

      return artigos;
    } catch (e) {
      return null;
    }
  }

  Future<List<Artigo>> _fetch() async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return List<Artigo>();
      } else {
        String nome_email = sessao["nome"].toString();
        Map<String, dynamic> parsed = Map<String, dynamic>();
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();

        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/ArtigoController/Artigo/listaarmazem',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          dynamic data = json.decode(response.body);
          data = json.decode(data)["DataSet"]["Table"];
          ToList lista = new ToList();
          artigoListaDisplayFiltro.clear();
          for (dynamic rawArtigo in data) {
            Artigo _artigo = Artigo.fromJson(rawArtigo);
            if (!artigoListaDisplay.contains(_artigo))
              artigoListaDisplay.add(_artigo);
            bool rv =
                existeArtigoNaLista(artigoListaDisplayFiltro, _artigo.artigo);
            if (rv == false)
              artigoListaDisplayFiltro.add(_artigo);
            else
              artigoListaDisplayFiltro.forEach((element) {
                if (element.artigo == _artigo.artigo) {
                  element.artigoArmazem.add(_artigo.artigoArmazem.first);
                }
              });
          }
          lista.items.addAll(artigoListaDisplayFiltro);
          await saveCacheData("artigo", lista);
          await setArtigoArmazemLote();
          return artigoListaDisplayFiltro;
        } else if (response.statusCode == 401) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING

          await SessaoApiProvider.refreshToken();
          return await _fetch();
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro " + msg);
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  bool existeArtigoNaLista(List<dynamic> lista, keyword) {
    bool rv = false;
    for (dynamic _artigo in lista) {
      if (_artigo.artigo == keyword) {
        rv = true;
        break;
      }
    }

    return rv;
  }
}
