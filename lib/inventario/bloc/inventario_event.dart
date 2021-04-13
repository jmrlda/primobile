part of 'inventario_bloc.dart';

abstract class InventarioEvent extends Equatable {
  const InventarioEvent();

  @override
  List<Object> get props => [];
}

class InventarioFetched extends InventarioEvent {}

class InventarioSearched extends InventarioEvent {}
