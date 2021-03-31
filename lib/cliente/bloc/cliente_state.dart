part of 'cliente_bloc.dart';

abstract class ClienteState extends Equatable {
  const ClienteState();

  @override
  List<Object> get props => [];
}

class ClienteInicial extends ClienteState {}

class ClienteFalha extends ClienteState {}

class ClienteSucesso extends ClienteState {
  final List<Cliente> clientes;
  final bool hasReachedMax;

  const ClienteSucesso({this.clientes, this.hasReachedMax});

  ClienteSucesso copyWith({
    List<Cliente> clientes,
    bool hasReachedMax,
  }) {
    return ClienteSucesso(
      clientes: clientes ?? this.clientes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [clientes, hasReachedMax];

  @override
  String toString() =>
      'ClienteSucesso { clientes: ${clientes.length}, hasReachedMax: $hasReachedMax }';
}

class ClienteSucessoPesquisa extends ClienteState {
  final List<Cliente> clientes;
  final bool hasReachedMax;
  final String query;
  const ClienteSucessoPesquisa({this.clientes, this.query, this.hasReachedMax});

  ClienteSucessoPesquisa copyWith({
    List<Cliente> artigos,
    String query,
    bool hasReachedMax,
  }) {
    return ClienteSucessoPesquisa(
      clientes: clientes ?? this.clientes,
      query: this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [clientes, hasReachedMax, query];

  @override
  String toString() =>
      'ClienteSucessoPesquisa { clientes: ${clientes.length}, query: $query},  hasReachedMax: $hasReachedMax}';
}
