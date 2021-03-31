part of 'cliente_bloc.dart';

abstract class ClienteEvent extends Equatable {
  const ClienteEvent();

  @override
  List<Object> get props => [];
}

class ClienteFetched extends ClienteEvent {}

class ClienteSearched extends ClienteEvent {}
