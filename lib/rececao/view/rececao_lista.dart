import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/artigos.dart';
import 'package:primobile/artigo/widgets/bottom_loader.dart';
import 'package:primobile/rececao/bloc/bloc.dart';
import 'package:primobile/rececao/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/rececao/widgets/widgets.dart';
import 'package:primobile/util/util.dart';

class RececaoLista extends StatefulWidget {
  RececaoLista({Key key, this.title, this.isSelected = false})
      : super(key: key);

  final String title;
  final bool isSelected;

  @override
  _RececaoLista createState() => _RececaoLista(isSeleted: isSelected);
}

class _RececaoLista extends State<RececaoLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final bool isSeleted;
  List<ArtigoRececao> data;
  _RececaoLista({this.isSeleted = false});
  RececaoBloc _rececaoBloc;
  http.Client httpClient = http.Client();
  var sessao;
  String token;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _rececaoBloc = BlocProvider.of<RececaoBloc>(context);

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
    return BlocBuilder<RececaoBloc, RececaoState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is RececaoInicial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is RececaoFalha) {
          return Center(
            child: Text('falha na busca por Rececao'),
          );
        }

        if (state is RececaoSemConexao) {
          return Center(
            child: Text('Verifique sua conexão ou aguarde!'),
          );
        }
        if (state is RececaoSucesso) {
          if (state.rececao.isEmpty) {
            return Center(
              child: Text('Sem rececao'),
            );
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.rececao.length
                  ? BottomLoader()
                  : RececaoListaItem(
                      rececao: state.rececao[index],
                      rececaoBloc: _rececaoBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.rececao.length
                : state.rececao.length + 1,
            controller: _scrollController,
          );
        }

        if (state is RececaoSucessoPesquisa) {
          if (state.rececao.isEmpty) {
            return Center(
              child: Text('Nenhum Rececao encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.rececao.length
                  ? BottomLoader()
                  : RececaoListaItem(
                      rececao: state.rececao[index],
                      rececaoBloc: _rececaoBloc,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.rececao.length
                : state.rececao.length + 1,
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
