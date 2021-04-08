part of 'rececao_bloc.dart';

abstract class RececaoState extends Equatable {
  const RececaoState();

  @override
  List<Object> get props => [];
}

class RececaoInicial extends RececaoState {}

class RececaoFalha extends RececaoState {}

class RececaoSucesso extends RececaoState {
  final List<Rececao> rececao;
  final bool hasReachedMax;

  const RececaoSucesso({this.rececao, this.hasReachedMax});

  RececaoSucesso copyWith({
    List<Rececao> rececao,
    bool hasReachedMax,
  }) {
    return RececaoSucesso(
      rececao: rececao ?? this.rececao,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [rececao, hasReachedMax];

  @override
  String toString() =>
      'RececaoSucesso { rececao: ${rececao.length}, hasReachedMax: $hasReachedMax }';
}

class RececaoSucessoPesquisa extends RececaoState {
  final List<Rececao> rececao;
  final bool hasReachedMax;
  final String query;
  const RececaoSucessoPesquisa({this.rececao, this.query, this.hasReachedMax});

  RececaoSucessoPesquisa copyWith({
    List<Rececao> artigos,
    String query,
    bool hasReachedMax,
  }) {
    return RececaoSucessoPesquisa(
      rececao: rececao ?? this.rececao,
      query: this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [rececao, hasReachedMax, query];

  @override
  String toString() =>
      'RececaoSucessoPesquisa { rececao: ${rececao.length}, query: $query},  hasReachedMax: $hasReachedMax}';
}
