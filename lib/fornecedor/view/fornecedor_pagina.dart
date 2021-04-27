import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/fornecedor/util.dart';
import 'package:primobile/fornecedor/widgets/fornecedor_appbar.dart';
import 'package:primobile/fornecedor/widgets/fornecedor_body.dart';

class FornecedorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ArtigoBloc _artigoBloc = ArtigoBloc(httpClient: http.Client())
      ..add(ArtigoFetched());
    return Scaffold(
      appBar: fornecedorAppBar(),
      body: BlocProvider(
        create: (BuildContext context) => _artigoBloc,
        // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
        child: artigoBody(context, _artigoBloc),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          // Navigator.pop(context, listaArtigoSelecionado);
        },
      ),
    );
  }
}
