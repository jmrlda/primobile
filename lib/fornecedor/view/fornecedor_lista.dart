import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/fornecedor/bloc/fornecedor_bloc.dart';
import 'package:primobile/fornecedor/widgets/bottom_loader.dart';
import 'package:primobile/fornecedor/widgets/fornecedor_lista_item.dart';
import 'package:primobile/util/util.dart';

class FornecedorLista extends StatefulWidget {
  FornecedorLista({Key key, this.title, this.isSelected}) : super(key: key);

  final String title;
  final bool isSelected;

  @override
  _FornecedorLista createState() => _FornecedorLista(isSeleted: isSelected);
}

class _FornecedorLista extends State<FornecedorLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  FornecedorBloc _fornecedorBloc;
  final bool isSeleted;
  _FornecedorLista({this.isSeleted = false});

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fornecedorBloc = BlocProvider.of<FornecedorBloc>(context);

    try {
      updateConnection(() {
        if (this.mounted)
          setState(() {
            PRIMARY_COLOR = CONEXAO_ON_COLOR;
          });
      }, () {
        if (this.mounted)
          setState(() {
            PRIMARY_COLOR = CONEXAO_OFF_COLOR;
          });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FornecedorBloc, FornecedorState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is FornecedorInicial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FornecedorFalha) {
          return Center(
            child: Text('falha na busca por fornecedor'),
          );
        }
        if (state is FornecedorSucesso) {
          if (state.fornecedores.isEmpty) {
            return Center(
              child: Text('Sem fornecedor'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.fornecedores.length
                  ? BottomLoader()
                  : FornecedorListaItem(
                      fornecedor: state.fornecedores[index],
                      fornecedorBloc: _fornecedorBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.fornecedores.length
                : state.fornecedores.length + 1,
            controller: _scrollController,
          );
        }

        if (state is FornecedorSucessoPesquisa) {
          if (state.fornecedores.isEmpty) {
            return Center(
              child: Text('Nenhum fornecedor encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.fornecedores.length
                  ? BottomLoader()
                  : FornecedorListaItem(
                      fornecedor: state.fornecedores[index],
                      fornecedorBloc: _fornecedorBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.fornecedores.length
                : state.fornecedores.length + 1,
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
      // _fornecedorBloc.add(FornecedorFetched());
    }
  }
}
