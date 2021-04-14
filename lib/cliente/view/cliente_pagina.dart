import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/cliente/cliente.dart';
import 'package:primobile/cliente/widgets/cliente_appbar.dart';

class ClientePage extends StatelessWidget {
  final bool isSelected;
  ClientePage({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    ClienteBloc _clienteBloc = ClienteBloc(httpClient: http.Client())
      ..add(ClienteFetched());
    return Scaffold(
      appBar: clienteAppBar(context),
      body: BlocProvider(
        create: (BuildContext context) => _clienteBloc,
        // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
        child: clienteBody(context, _clienteBloc, this.isSelected),
      ),
    );
  }
}
