part of 'fornecedor_bloc.dart';

abstract class FornecedorState extends Equatable {
  const FornecedorState();

  @override
  List<Object> get props => [];
}

class FornecedorInicial extends FornecedorState {}

class FornecedorFalha extends FornecedorState {}

class FornecedorSucesso extends FornecedorState {
  final List<Fornecedor> fornecedores;
  final bool hasReachedMax;

  const FornecedorSucesso({this.fornecedores, this.hasReachedMax});

  FornecedorSucesso copyWith({
    List<Fornecedor> fornecedores,
    bool hasReachedMax,
  }) {
    return FornecedorSucesso(
      fornecedores: fornecedores ?? this.fornecedores,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [fornecedores, hasReachedMax];

  @override
  String toString() =>
      'FornecedorSucesso { fornecedores: ${fornecedores.length}, hasReachedMax: $hasReachedMax }';
}

class FornecedorSucessoPesquisa extends FornecedorState {
  final List<Fornecedor> fornecedores;
  final bool hasReachedMax;
  final String query;
  const FornecedorSucessoPesquisa(
      {this.fornecedores, this.query, this.hasReachedMax});

  FornecedorSucessoPesquisa copyWith({
    List<Fornecedor> artigos,
    String query,
    bool hasReachedMax,
  }) {
    return FornecedorSucessoPesquisa(
      fornecedores: fornecedores ?? this.fornecedores,
      query: this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [fornecedores, hasReachedMax, query];

  @override
  String toString() =>
      'FornecedorSucessoPesquisa { fornecedores: ${fornecedores.length}, query: $query},  hasReachedMax: $hasReachedMax}';
}
