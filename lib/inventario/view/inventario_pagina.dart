import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/inventario/bloc/bloc.dart';
import 'package:primobile/inventario/widgets/widgets.dart';

class InventarioPage extends StatelessWidget {
  final bool isSelected;
  InventarioPage({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    InventarioBloc _inventarioBloc = InventarioBloc(httpClient: http.Client())
      ..add(InventarioFetched());
    return Scaffold(
      appBar: inventarioAppBar(context),
      body: BlocProvider(
        create: (BuildContext context) => _inventarioBloc,
        // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
        child: inventarioBody(context, _inventarioBloc, this.isSelected),
      ),
    );
  }
}
