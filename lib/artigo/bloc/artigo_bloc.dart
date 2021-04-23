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
        }

        if (currentState is ArtigoSucesso) {
          // final artigos = await _fetchArtigos(currentState.artigos.length, 20);
          yield currentState.artigos.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ArtigoSucesso(
                  artigos: currentState.artigos, hasReachedMax: true);
        }

        if (currentState is ArtigoSucessoPesquisa) {
          final artigos = await _fetchArtigos(0, 20);
          yield ArtigoSucesso(artigos: artigos, hasReachedMax: true);
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
        }

        if (currentState is ArtigoSucesso) {
          final artigos =
              artigoPesquisar(this.query, await _fetchArtigos(0, 20));
          yield ArtigoSucessoPesquisa(
              artigos: artigos, hasReachedMax: true, query: this.query);
          return;
        }

        if (currentState is ArtigoSucessoPesquisa) {
          final artigos = artigoPesquisar(
              this.query, await _fetchArtigos(currentState.artigos.length, 20));
          yield artigos.isEmpty
              ? currentState.copyWith()
              : ArtigoSucessoPesquisa(
                  artigos: artigos, hasReachedMax: true, query: this.query);
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

  Future<List<Artigo>> _fetchArtigos(int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      List<Artigo> lista_artigos = List<Artigo>();

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
            protocolo + baseUrl + '/WebApi/ArtigoController/Artigo/lista',
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          dynamic data = json.decode(response.body);
          data = json.decode(data)["DataSet"]["Table"];

          for (dynamic rawArtigo in data) {
            lista_artigos.add(Artigo.fromJson(rawArtigo));
          }

          return lista_artigos;
        } else if (response.statusCode == 401 || response.statusCode == 500) {
          //  #TODO informar ao usuario sobre a renovação da sessão
          // mostrando mensagem e um widget de LOADING
          lista_artigos = List<Artigo>();

          return lista_artigos;
        } else {
          final msg = json.decode(response.body);
          print("Ocorreu um erro" + msg["Message"]);
        }
      }
    } catch (e) {
      throw e;

      // return 3;
    }

    // } else {
    //   throw Exception('Erro na busca por artigos');
    // }
  }
}
