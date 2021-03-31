part of 'expedicao_bloc.dart';

abstract class ExpedicaoEvent extends Equatable {
  const ExpedicaoEvent();

  @override
  List<Object> get props => [];
}

class ExpedicaoFetched extends ExpedicaoEvent {}

class ExpedicaoSearched extends ExpedicaoEvent {}
