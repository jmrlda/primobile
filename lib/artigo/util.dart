import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:primobile/artigo/models/artigo.dart';

import 'bloc/bloc.dart';

List<Artigo> artigoListaDisplay = new List<Artigo>();
List<Artigo> artigoListaDisplayFiltro = new List<Artigo>();

// List<Artigo> artigoListaArmazemDisplay = new List<Artigo>();
Map<String, List<String>> artigoListaArmazemDisplay =
    Map<String, List<String>>();
List<Artigo> artigosDuplicado = new List<Artigo>();
List<Artigo> listaArtigoSelecionado = List<Artigo>();
bool isSelected = false;

String baseUrl = "";
String url = "";
TextEditingController artigoPesquisarController = TextEditingController();
ArtigoBloc artigoBloc;

void opcaoAcao(String opcao) async {
  if (opcao == 'sincronizar') {}
}

// metodo para busca de artigos na lista
List<Artigo> artigoPesquisar(String query, List<Artigo> listaArtigo) {
  List<Artigo> resultado = List<Artigo>();

  if (query.trim().isNotEmpty) {
    for (Artigo item in listaArtigo) {
      if (item.descricao
              .toLowerCase()
              .contains(query.toString().toLowerCase()) ||
          item.artigo.toLowerCase().contains(query.toString().toLowerCase())) {
        resultado.add(item);
      }
    }
    ;
  }
  return resultado;
}

// ao selecionar um artigo, adicionar a lista
// de artigos selecionados, se o artigo ja tiver
// sido selecionado remover da lista.
bool adicionarArtigo(Artigo a) {
  bool existe = false;
  for (var i = 0; i < listaArtigoSelecionado.length; i++) {
    if (listaArtigoSelecionado[i].artigo == a.artigo) {
      existe = true;
      listaArtigoSelecionado.removeAt(i);
    }
  }

  if (!existe) {
    listaArtigoSelecionado.add(a);
  }

  return existe;
}

bool existeArtigoSelecionado(Artigo a) {
  bool existe = false;

  for (var i = 0; i < listaArtigoSelecionado.length; i++) {
    if (listaArtigoSelecionado[i].artigo == a.artigo) {
      existe = true;
      break;
    }
  }
  return existe;
}

List<DataRow> buildArtigoArmazemDataRow(
  Artigo artigo,
) {
  List<DataRow> listaDataRow = List<DataRow>();
  String armazem = "";

  for (int i = 0; i < artigo.artigoArmazem.length; i++) {
    armazem = artigo.artigoArmazem[i].artigoArmazemId();
    listaDataRow.add(DataRow(
      cells: <DataCell>[
        DataCell(
          Text(artigo.artigoArmazem[i].armazem, style: TextStyle(fontSize: 11)),
        ),
        DataCell(Text(artigo.artigoArmazem[i].localizacao,
            style: TextStyle(fontSize: 11))),
        DataCell(
            Text(artigo.artigoArmazem[i].lote, style: TextStyle(fontSize: 11))),
        DataCell(Text(artigo.artigoArmazem[i].quantidadeStock.toString(),
            style: TextStyle(fontSize: 11))),
      ],
    ));
  }

  return listaDataRow;
}
