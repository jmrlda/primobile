import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/artigos.dart';
import 'package:primobile/artigo/widgets/bottom_loader.dart';
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/expedicao/models/models.dart';
import 'package:primobile/expedicao/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class ExpedicaoLista extends StatefulWidget {
  ExpedicaoLista({Key key, this.title, this.isSelected = false})
      : super(key: key);

  final String title;
  final bool isSelected;

  @override
  _ExpedicaoLista createState() => _ExpedicaoLista(isSeleted: isSelected);
}

class _ExpedicaoLista extends State<ExpedicaoLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final bool isSeleted;
  List<ArtigoExpedicao> data;
  _ExpedicaoLista({this.isSeleted = false});
  ExpedicaoBloc _expedicaoBloc;
  http.Client httpClient = http.Client();
  var sessao;
  String token;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _expedicaoBloc = BlocProvider.of<ExpedicaoBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpedicaoBloc, ExpedicaoState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is ExpedicaoInicial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ExpedicaoFalha) {
          return Center(
            child: Text('falha na busca por Expedicao'),
          );
        }
        if (state is ExpedicaoSucesso) {
          if (state.expedicao.isEmpty) {
            return Center(
              child: Text('Sem expedicao'),
            );
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.expedicao.length
                  ? BottomLoader()
                  : ExpedicaoListaItem(
                      expedicao: state.expedicao[index],
                      expedicaoBloc: _expedicaoBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.expedicao.length
                : state.expedicao.length + 1,
            controller: _scrollController,
          );
        }

        if (state is ExpedicaoSucessoPesquisa) {
          if (state.expedicao.isEmpty) {
            return Center(
              child: Text('Nenhum expedicao encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.expedicao.length
                  ? BottomLoader()
                  : ExpedicaoListaItem(
                      expedicao: state.expedicao[index],
                      expedicaoBloc: _expedicaoBloc,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.expedicao.length
                : state.expedicao.length + 1,
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
