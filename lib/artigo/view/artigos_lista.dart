import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:primobile/artigo/widgets/artigo_lista_item.dart';
import 'package:primobile/artigo/widgets/bottom_loader.dart';
import 'package:primobile/util/util.dart';

import '../util.dart';

class ArtigoLista extends StatefulWidget {
  ArtigoLista({Key key, this.title, this.isSelected = false}) : super(key: key);

  final String title;
  final bool isSelected;

  @override
  _ArtigoLista createState() => _ArtigoLista(isSelected: isSelected);
}

class _ArtigoLista extends State<ArtigoLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  // ArtigoBloc artigoBloc;
  final bool isSelected;

  _ArtigoLista({this.isSelected = false});

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // artigoBloc = BlocProvider.of<ArtigoBloc>(context);

    try {
      updateConnection(() {
        setState(() {
          PRIMARY_COLOR = CONEXAO_ON_COLOR;
        });
      }, () {
        setState(() {
          PRIMARY_COLOR = CONEXAO_OFF_COLOR;
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtigoBloc, ArtigoState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is ArtigoInicial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ArtigoFalha) {
          return Center(
            child: Text('falha na busca por artigos!'),
          );
        }
        if (state is ArtigoSucesso) {
          if (state.artigos.isEmpty) {
            return Center(
              child: Text('Sem artigos!'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.artigos.length
                  ? BottomLoader()
                  : ArtigoListaItem(
                      artigo: state.artigos[index],
                      // artigoBloc: artigoBloc,
                      isSelected: this.isSelected,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.artigos.length
                : state.artigos.length + 1,
            controller: _scrollController,
          );
        }

        if (state is ArtigoSucessoPesquisa) {
          if (state.artigos.isEmpty) {
            return Center(
              child: Text('Artigo não encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.artigos.length
                  ? BottomLoader()
                  : ArtigoListaItem(
                      artigo: state.artigos[index],
                      // artigoBloc: artigoBloc,
                      isSelected: this.isSelected,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.artigos.length
                : state.artigos.length + 1,
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
      // artigoBloc.add(ArtigoFetched());
    }
  }
}
