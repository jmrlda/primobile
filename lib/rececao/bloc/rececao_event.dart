part of 'rececao_bloc.dart';

abstract class RececaoEvent extends Equatable {
  const RececaoEvent();

  @override
  List<Object> get props => [];
}

class RececaoFetched extends RececaoEvent {}

class RececaoSearched extends RececaoEvent {}
