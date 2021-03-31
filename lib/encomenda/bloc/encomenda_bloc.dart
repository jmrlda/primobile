import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'encomenda_event.dart';
part 'encomenda_state.dart';

class EncomendaBloc extends Bloc<EncomendaEvent, EncomendaState> {
  EncomendaBloc() : super(EncomendaInitial());

  @override
  Stream<EncomendaState> mapEventToState(
    EncomendaEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
