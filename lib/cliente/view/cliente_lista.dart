import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primobile/artigo/widgets/bottom_loader.dart';
import 'package:primobile/cliente/bloc/bloc.dart';
import 'package:primobile/cliente/cliente.dart';
import 'package:primobile/util/util.dart';

class ClienteLista extends StatefulWidget {
  ClienteLista({Key key, this.title, this.isSelected = false})
      : super(key: key);

  final String title;
  final bool isSelected;
  @override
  _ClienteLista createState() => _ClienteLista(isSeleted: isSelected);
}

class _ClienteLista extends State<ClienteLista> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final bool isSeleted;
  _ClienteLista({this.isSeleted = false});
  ClienteBloc _clienteBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _clienteBloc = BlocProvider.of<ClienteBloc>(context);

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
    return BlocBuilder<ClienteBloc, ClienteState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is ClienteInicial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ClienteFalha) {
          return Center(
            child: Text('falha na busca por cliente'),
          );
        }
        if (state is ClienteSucesso) {
          if (state.clientes.isEmpty) {
            return Center(
              child: Text('Sem cliente'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.clientes.length
                  ? BottomLoader()
                  : ClienteListaItem(
                      cliente: state.clientes[index],
                      clienteBloc: _clienteBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.clientes.length
                : state.clientes.length + 1,
            controller: _scrollController,
          );
        }

        if (state is ClienteSucessoPesquisa) {
          if (state.clientes.isEmpty) {
            return Center(
              child: Text('Nenhum cliente encontrado'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.clientes.length
                  ? BottomLoader()
                  : ClienteListaItem(
                      cliente: state.clientes[index],
                      clienteBloc: _clienteBloc,
                      isSelected: this.isSeleted,
                    );
            },
            itemCount: state.hasReachedMax
                ? state.clientes.length
                : state.clientes.length + 1,
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
