part of 'encomenda_bloc.dart';

abstract class EncomendaState extends Equatable {
  const EncomendaState();
  
  @override
  List<Object> get props => [];
}

class EncomendaInitial extends EncomendaState {}
