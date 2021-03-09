part of 'artigo_bloc.dart';

@immutable
abstract class ArtigoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ArtigoFetched extends ArtigoEvent {}

class ArtigoSearched extends ArtigoEvent {}
