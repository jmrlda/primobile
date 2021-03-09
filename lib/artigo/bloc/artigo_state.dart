part of 'artigo_bloc.dart';

@immutable
abstract class ArtigoState extends Equatable {
  const ArtigoState();

  @override
  List<Object> get props => [];
}

class ArtigoInicial extends ArtigoState {}

class ArtigoFalha extends ArtigoState {}

class ArtigoSucesso extends ArtigoState {
  final List<Artigo> artigos;
  final bool hasReachedMax;

  const ArtigoSucesso({this.artigos, this.hasReachedMax});

  ArtigoSucesso copyWith({
    List<Artigo> artigos,
    bool hasReachedMax,
  }) {
    return ArtigoSucesso(
      artigos: artigos ?? this.artigos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [artigos, hasReachedMax];

  @override
  String toString() =>
      'ArtigoSucesso { artigos: ${artigos.length}, hasReachedMax: $hasReachedMax }';
}

class ArtigoSucessoPesquisa extends ArtigoState {
  final List<Artigo> artigos;
  final bool hasReachedMax;
  final String query;
  const ArtigoSucessoPesquisa({this.artigos, this.query, this.hasReachedMax});

  ArtigoSucessoPesquisa copyWith({
    List<Artigo> artigos,
    String query,
    bool hasReachedMax,
  }) {
    return ArtigoSucessoPesquisa(
      artigos: artigos ?? this.artigos,
      query: this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [artigos, hasReachedMax, query];

  @override
  String toString() =>
      'ArtigoSucessoPesquisa { artigos: ${artigos.length}, query: $query},  hasReachedMax: $hasReachedMax}';
}
