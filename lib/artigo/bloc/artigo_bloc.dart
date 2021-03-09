import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// local
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
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
          final artigos = await _fetchArtigos(0, 20);
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
          final artigos = artigoPesquisar(
              this.query != null ? this.query : 'barra',
              await _fetchArtigos(0, 20));
          yield ArtigoSucessoPesquisa(
              artigos: artigos, hasReachedMax: true, query: this.query);
          return;
        }

        if (currentState is ArtigoSucessoPesquisa) {
          final artigos = artigoPesquisar(
              this.query != null ? this.query : 'barra',
              await _fetchArtigos(currentState.artigos.length, 20));
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
    List lista = [
      {
        "artigo": "00252",
        "descricao": "Nutro Bacon Extra (1/2) Kg (00382)",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 693.782,
        "preco": 1226.0,
        "unidade": "KG",
        "pvp1": 1226.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00253",
        "descricao": "Nutro Cabeca Fumada Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 17.916,
        "preco": 565.0,
        "unidade": "KG",
        "pvp1": 565.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00254",
        "descricao": "Nutro Chouricao Redondo Kg ",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 60.425,
        "preco": 572.0,
        "unidade": "KG",
        "pvp1": 572.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00255",
        "descricao": "Nutro Chouricao Barra Kg ",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 116.151,
        "preco": 494.0,
        "unidade": "KG",
        "pvp1": 494.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00256",
        "descricao": "Nutro Chourico de Carne Corrente Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 5.131,
        "preco": 485.0,
        "unidade": "KG",
        "pvp1": 485.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00258",
        "descricao": "Nutro Chourica Serrana c/Pimentao Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 14.494,
        "preco": 1016.0,
        "unidade": "KG",
        "pvp1": 1016.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00260",
        "descricao": "Nutro Chourico Criolo (2Un) Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 9.582,
        "preco": 630.0,
        "unidade": "KG",
        "pvp1": 630.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00261",
        "descricao": "Nutro Farinheira Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 24.8,
        "preco": 562.0,
        "unidade": "KG",
        "pvp1": 562.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 391.3,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00264",
        "descricao": "Nutro Fiambre Sandwich Barra Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 187.244,
        "preco": 415.0,
        "unidade": "KG",
        "pvp1": 415.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00265",
        "descricao": "Nutro Morcela Kg ",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 12.8,
        "preco": 562.0,
        "unidade": "KG",
        "pvp1": 562.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00266",
        "descricao": "Nutro Paio York (1/2) Kg ",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 69.064,
        "preco": 990.0,
        "unidade": "KG",
        "pvp1": 990.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00267",
        "descricao": "Nutro Fiambre Peito Frango Barra Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 146.755,
        "preco": 870.0,
        "unidade": "KG",
        "pvp1": 870.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00268",
        "descricao": "Nutro Fiambre Peito Peru Barra Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 46.158,
        "preco": 998.0,
        "unidade": "KG",
        "pvp1": 998.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00270",
        "descricao": "Nutro Presunto Cura Natural (1/2) Kg ",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 87.141,
        "preco": 1225.0,
        "unidade": "KG",
        "pvp1": 1225.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00301",
        "descricao": "Nutro Misto Fumeiro Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 119.795,
        "preco": 640.0,
        "unidade": "KG",
        "pvp1": 640.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00302",
        "descricao": "Nutro Pa Fumada 1/2 Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 125.656,
        "preco": 912.0,
        "unidade": "KG",
        "pvp1": 912.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00324",
        "descricao": "Nutro Unha Fumada Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 16.475,
        "preco": 460.0,
        "unidade": "KG",
        "pvp1": 460.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00331",
        "descricao": "Nutro Mortadela Minhota Kg ",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 67.582,
        "preco": 432.0,
        "unidade": "KG",
        "pvp1": 432.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00338",
        "descricao": "Nutro Mortadela c/Azeitonas Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 37.543,
        "preco": 478.0,
        "unidade": "KG",
        "pvp1": 478.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00358",
        "descricao": "Nutro Queijo Flamengo 1/2 Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 168.111,
        "preco": 860.0,
        "unidade": "KG",
        "pvp1": 860.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00359",
        "descricao": "Nutro Queijo Flamengo 1/4 Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 37.919,
        "preco": 860.0,
        "unidade": "KG",
        "pvp1": 860.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00360",
        "descricao": "Nutro Queijo Flamengo Barra Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 1094.389,
        "preco": 718.0,
        "unidade": "KG",
        "pvp1": 718.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00361",
        "descricao": "Nutro Queijo Mozzarella Barra Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 101.542,
        "preco": 725.0,
        "unidade": "KG",
        "pvp1": 725.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00369",
        "descricao": "Nutro Pernil Fumado Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 7.103,
        "preco": 588.0,
        "unidade": "KG",
        "pvp1": 588.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "00376",
        "descricao": "Nutro Ouvidos Fumados Kg",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 0.528,
        "preco": 920.0,
        "unidade": "KG",
        "pvp1": 920.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 0.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
      {
        "artigo": "0121",
        "descricao": "Sesame Oil Sauce 210ml",
        "civa": 17.0,
        "iva": 17.0,
        "quantidade": 24.0,
        "preco": 1010.0,
        "unidade": "UN",
        "pvp1": 1010.0,
        "pvp1Iva": true,
        "pvp2": 0.0,
        "pvp2Iva": true,
        "pvp3": 0.0,
        "pvp3Iva": true,
        "pvp4": 1380.0,
        "pvp4Iva": true,
        "pvp5": 0.0,
        "pvp5Iva": true,
        "pvp6": 0.0,
        "pvp6Iva": true,
        "imagemBuffer": ""
      },
    ];
    // final response = await httpClient.get(
    // 'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    // 'http://197.249.47.140:9191/api/artigo');

    // if (response.statusCode == 200) {
    final List data = lista; //json.decode(response.body) as List;
    return data.map((rawArtigo) {
      return Artigo.fromJson(rawArtigo);
    }).toList();
    // } else {
    //   throw Exception('Erro na busca por artigos');
    // }
  }
}
