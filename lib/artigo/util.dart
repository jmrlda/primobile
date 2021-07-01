import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:primobile/artigo/models/artigo.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/util/util.dart';

import 'bloc/bloc.dart';
import 'package:uuid/uuid.dart';

List<Artigo> artigoListaDisplay = new List<Artigo>();
List<Artigo> artigoListaDisplayFiltro = new List<Artigo>();
List<ArtigoLote> listaLote = new List<ArtigoLote>();
Map<String, List<ArtigoLote>> mapaListaLote = Map<String, List<ArtigoLote>>();
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

Future<List<ArtigoLote>> getLoteInCache() async {
  List<ArtigoLote> lista = new List<ArtigoLote>();
  try {
    dynamic data = json.decode(await getCacheData("lote"));
    if (data != null) {
      if (data.length > 0) {
        for (dynamic lote in data) {
          lista.add(ArtigoLote.fromJson(lote));
        }
      }
    }
  } catch (e) {
    lista = null;
  }

  return lista;
}

Future<void> setArtigoArmazemLote() {
  // artigoListaDisplayFiltro.f
  ArtigoLote lote = new ArtigoLote();

  for (int i = 0; i < artigoListaDisplayFiltro.length; i++) {
    Artigo _artigo = artigoListaDisplayFiltro[i];
    if (mapaListaLote[_artigo.artigo] != null) {
      // armazem = _artigo.artigoArmazem.first;

      mapaListaLote[_artigo.artigo].forEach((element) {
        ArtigoArmazem armazem = new ArtigoArmazem();

        armazem.lote = element.lote;
        armazem.localizacao = _artigo.artigoArmazem.first.localizacao;
        armazem.armazem = _artigo.artigoArmazem.first.armazem;
        armazem.resetQuantidade();

        artigoListaDisplayFiltro[i].artigoArmazem.add(armazem);
      });
    }
  }
}
