import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/artigo/util.dart';
import 'package:primobile/artigo/widgets/artigo_appbar.dart';
import 'package:primobile/artigo/widgets/artigo_body.dart';

class ArtigoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ArtigoBloc _artigoBloc = ArtigoBloc(httpClient: http.Client())
      ..add(ArtigoFetched());
    return Scaffold(
      appBar: artigoAppBar(),
      body: BlocProvider(
        create: (BuildContext context) => _artigoBloc,
        // ArtigoBloc(httpClient: http.Client())..add(ArtigoFetched()),
        child: artigoBody(context, _artigoBloc),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          Navigator.pop(context, listaArtigoSelecionado);
        },
      ),
    );
  }
}
