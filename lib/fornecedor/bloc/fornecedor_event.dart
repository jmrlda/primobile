part of 'fornecedor_bloc.dart';

abstract class FornecedorEvent extends Equatable {
  const FornecedorEvent();

  @override
  List<Object> get props => [];
}

class FornecedorFetched extends FornecedorEvent {}

class FornecedorSearched extends FornecedorEvent {}
