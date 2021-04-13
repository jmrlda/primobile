import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/artigos.dart';
import 'package:primobile/artigo/widgets/bottom_loader.dart';
import 'package:primobile/inventario/bloc/bloc.dart';
import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/inventario/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class InventarioLista extends StatefulWidget {
  InventarioLista({Key key, this.title, this.isSelected = false})
      : super(key: key);

  final String title;
  final bool isSelected;

  @override
  _InventarioLista createState() => _InventarioLista(isSeleted: isSelected);
}

class _InventarioLista extends State<InventarioLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final bool isSeleted;
  List<ArtigoInventario> data;
  _InventarioLista({this.isSeleted = false});
  InventarioBloc _inventarioBloc;
  http.Client httpClient = http.Client();
  var sessao;
  String token;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _inventarioBloc = BlocProvider.of<InventarioBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventarioBloc, InventarioState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is InventarioInicial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is InventarioFalha) {
          return Center(
            child: Text('falha na busca por Inventario'),
          );
        }
        if (state is InventarioSucesso) {
          if (state.inventario.isEmpty) {
            return Center(
              child: Text('Sem inventario'),
            );
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.inventario.length
                  ? BottomLoader()
                  : InventarioListaItem(
                      inventario: state.inventario[index],
                      inventarioBloc: _inventarioBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.inventario.length
                : state.inventario.length + 1,
            controller: _scrollController,
          );
        }

        if (state is InventarioSucessoPesquisa) {
          if (state.inventario.isEmpty) {
            return Center(
              child: Text('Nenhum inventario encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.inventario.length
                  ? BottomLoader()
                  : InventarioListaItem(
                      inventario: state.inventario[index],
                      inventarioBloc: _inventarioBloc,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.inventario.length
                : state.inventario.length + 1,
            controller: _scrollController,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // _artigoBloc.add(ArtigoFetched());
    }
  }
}
