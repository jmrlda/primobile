part of 'expedicao_bloc.dart';

abstract class ExpedicaoState extends Equatable {
  const ExpedicaoState();

  @override
  List<Object> get props => [];
}

class ExpedicaoInicial extends ExpedicaoState {}

class ExpedicaoFalha extends ExpedicaoState {}

class ExpedicaoSucesso extends ExpedicaoState {
  final List<Expedicao> expedicao;
  final bool hasReachedMax;

  const ExpedicaoSucesso({this.expedicao, this.hasReachedMax});

  ExpedicaoSucesso copyWith({
    List<Expedicao> expedicao,
    bool hasReachedMax,
  }) {
    return ExpedicaoSucesso(
      expedicao: expedicao ?? this.expedicao,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [expedicao, hasReachedMax];

  @override
  String toString() =>
      'ExpedicaoSucesso { expedicao: ${expedicao.length}, hasReachedMax: $hasReachedMax }';
}

class ExpedicaoSucessoPesquisa extends ExpedicaoState {
  final List<Expedicao> expedicao;
  final bool hasReachedMax;
  final String query;
  const ExpedicaoSucessoPesquisa(
      {this.expedicao, this.query, this.hasReachedMax});

  ExpedicaoSucessoPesquisa copyWith({
    List<Expedicao> artigos,
    String query,
    bool hasReachedMax,
  }) {
    return ExpedicaoSucessoPesquisa(
      expedicao: expedicao ?? this.expedicao,
      query: this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [expedicao, hasReachedMax, query];

  @override
  String toString() =>
      'ExpedicaoSucessoPesquisa { expedicao: ${expedicao.length}, query: $query},  hasReachedMax: $hasReachedMax}';
}
