part of 'inventario_bloc.dart';

abstract class InventarioState extends Equatable {
  const InventarioState();

  @override
  List<Object> get props => [];
}

class InventarioInicial extends InventarioState {}

class InventarioFalha extends InventarioState {}

class InventarioSucesso extends InventarioState {
  final List<Inventario> inventario;
  final bool hasReachedMax;

  const InventarioSucesso({this.inventario, this.hasReachedMax});

  InventarioSucesso copyWith({
    List<Inventario> inventario,
    bool hasReachedMax,
  }) {
    return InventarioSucesso(
      inventario: inventario ?? this.inventario,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [inventario, hasReachedMax];

  @override
  String toString() =>
      'InventarioSucesso { inventario: ${inventario.length}, hasReachedMax: $hasReachedMax }';
}

class InventarioSucessoPesquisa extends InventarioState {
  final List<Inventario> inventario;
  final bool hasReachedMax;
  final String query;
  const InventarioSucessoPesquisa(
      {this.inventario, this.query, this.hasReachedMax});

  InventarioSucessoPesquisa copyWith({
    List<Inventario> artigos,
    String query,
    bool hasReachedMax,
  }) {
    return InventarioSucessoPesquisa(
      inventario: inventario ?? this.inventario,
      query: this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [inventario, hasReachedMax, query];

  @override
  String toString() =>
      'InventarioSucessoPesquisa { inventario: ${inventario.length}, query: $query},  hasReachedMax: $hasReachedMax}';
}
