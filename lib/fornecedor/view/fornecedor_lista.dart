import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:primobile/artigo/widgets/bottom_loader.dart';
import 'package:primobile/fornecedor/widgets/fornecedor_lista_item.dart';

class FornecedorLista extends StatefulWidget {
  FornecedorLista({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FornecedorLista createState() => _FornecedorLista();
}

class _FornecedorLista extends State<FornecedorLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  ArtigoBloc _artigoBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _artigoBloc = BlocProvider.of<ArtigoBloc>(context);
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
            child: Text('falha na busca por artigos'),
          );
        }
        if (state is ArtigoSucesso) {
          if (state.artigos.isEmpty) {
            return Center(
              child: Text('Sem artigos'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.artigos.length
                  ? BottomLoader()
                  : FornecedorListaItem(
                      artigo: state.artigos[index],
                      artigoBloc: _artigoBloc,
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
              child: Text('Nenhum artigo encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.artigos.length
                  ? BottomLoader()
                  : FornecedorListaItem(
                      artigo: state.artigos[index],
                      artigoBloc: _artigoBloc,
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
      // _artigoBloc.add(ArtigoFetched());
    }
  }
}
