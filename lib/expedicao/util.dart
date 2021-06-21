import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/expedicao/bloc/bloc.dart';
import 'package:primobile/expedicao/models/artigo_expedicao.dart';
import 'package:primobile/expedicao/models/expedicao.dart';

List<Expedicao> listaExpedicaoSelecionado = List<Expedicao>();
List<Expedicao> listaExpedicaoDisplay = List<Expedicao>();
List<ArtigoExpedicao> listaArtigoExpedicaoDisplayFiltro =
    List<ArtigoExpedicao>();
List<ArtigoExpedicao> listaArtigoExpedicaoDisplay = List<ArtigoExpedicao>();

ExpedicaoBloc expedicaoBloc;
Map<String, List<String>> expedicaoListaArmazemDisplay =
    Map<String, List<String>>();
TextEditingController expedicaoPesquisarController = TextEditingController();
List<ArtigoExpedicao> lista_artigo_expedicao = List<ArtigoExpedicao>();

List<DataRow> buildInventarioDataRow(ArtigoExpedicao artigoObj) {
  List<DataRow> listaDataRow = List<DataRow>();
  String armazem = "";
  String artigo = artigoObj.artigo;

  // artigoListaDisplayFiltro

  Artigo _artigo = Artigo.getArtigo(artigoListaDisplayFiltro, artigo);

  // for (int i = 0; i < _artigo.artigoArmazem.length; i++) {
  // armazem = expedicaoListaArmazemDisplay[artigo][i];
  // _artigo.artigoArmazem.forEach((armazem) {
  for (int i = 0; i < _artigo.artigoArmazem.length; i++) {
    ArtigoArmazem armazem = _artigo.artigoArmazem[i];
    if (_artigo.artigoArmazem.length > 1 && armazem.lote == "<L01>") continue;
    listaDataRow.add(DataRow(
      cells: <DataCell>[
        DataCell(
          Text(armazem.armazem, style: TextStyle(fontSize: 11)),
        ),
        DataCell(Text(armazem.localizacao, style: TextStyle(fontSize: 11))),
        DataCell(Text(armazem.lote, style: TextStyle(fontSize: 11))),
        DataCell(Text(armazem.quantidadePendente.toString() ?? "0.0",
            style: TextStyle(fontSize: 11))),
        DataCell(TextFieldCustom(artigoObj, i)),
      ],
    ));
  }

  return listaDataRow;
}

// Atribuir quatidade ao artigo que tenha mesmo armazem, localizacao e lote.
void setArtigQuantidadeByArmazem(ArtigoExpedicao artigoExpedicao,
    double quantidade, Key artigoKey, int posicao) {
  // inventarioListaArmazemDisplay[artigo];
  bool found = false;
  // for (int i = 0; i < expedicaoListaArmazemDisplay[artigo].length; i++) {

  // artigoExpedicao.artigoObj.artigoArmazem.forEach((element) {
  // String _armazem = element.armazem;
  // String _loc = element.localizacao;
  // String _lote = element.lote;

  for (int j = 0; j < listaArtigoExpedicaoDisplayFiltro.length; j++) {
    ArtigoExpedicao _artInv = new ArtigoExpedicao();
    _artInv = listaArtigoExpedicaoDisplayFiltro[j];
    int i = 0;
    if (artigoExpedicao.artigo == listaArtigoExpedicaoDisplayFiltro[j].artigo) {
      // lista_artigo_expedicao[j].artigoObj. = quantidade;
      // element.quantidadeExpedir = quantidade;
      listaArtigoExpedicaoDisplayFiltro[j]
          .artigoObj
          .artigoArmazem[posicao]
          .quantidadeExpedir = quantidade;
      found = true;
      break;
    }
  }
  if (found) return;
// lista_artigo_inventario
  // });
}
// void setArtigQuantidadeByArmazem(
//     String artigo, double quantidade, String artigoKey) {
//   // inventarioListaArmazemDisplay[artigo];
//   bool found = false;
//   for (int i = 0; i < expedicaoListaArmazemDisplay[artigo].length; i++) {
//     String armazem = expedicaoListaArmazemDisplay[artigo][i];
//     List<String> arm = armazem.split("-");
//     String _armazem = arm[0] == "@" ? "" : arm[0];
//     String _loc = arm[1] == "@" ? "" : arm[1];
//     String _lote = arm[2] == "@" ? "" : arm[2];

//     for (int j = 0; j < lista_artigo_expedicao.length; j++) {
//       ArtigoExpedicao _artInv = new ArtigoExpedicao();
//       _artInv = lista_artigo_expedicao[j];
//       if (_artInv.artigo == artigo &&
//           _artInv.armazem == _armazem &&
//           _artInv.localizacao == _loc &&
//           _artInv.lote == _lote &&
//           artigoKey.contains(armazem)) {
//         lista_artigo_expedicao[j].quantidadeExpedir = quantidade;
//         found = true;
//         break;
//       }
//     }
//     if (found) break;
// // lista_artigo_inventario
//   }
// }
Widget TextFieldCustom(ArtigoExpedicao _artigoExpedicao, int posicao) {
  ArtigoArmazem _artigoArmazem =
      _artigoExpedicao.artigoObj.artigoArmazem[posicao];
  // final GlobalKey linhaInvKey = GlobalKey(debugLabel: armazem);
  Key linhaInvKey = new Key(_artigoArmazem.artigoArmazemId());
  TextEditingController _controller = new TextEditingController();
  _controller.text = _artigoArmazem.quantidadeExpedir.toString();
  return TextField(
    key: linhaInvKey,
    keyboardType: TextInputType.number,
    autofocus: false,
    style: TextStyle(fontSize: 13),
    textAlign: TextAlign.right,
    controller: _controller,
    onChanged: (value) {
      try {
        print(
            linhaInvKey.toString().contains(_artigoArmazem.artigoArmazemId()));
        if (double.parse(_controller.text) > 0) {
          setArtigQuantidadeByArmazem(_artigoExpedicao,
              double.parse(_controller.text), linhaInvKey, posicao);
        }
      } catch (e) {
        print(e);
      }
    },
    onTap: () {
      _controller.selection = TextSelection(
          baseOffset: 0, extentOffset: _controller.value.text.length);
    },
  );
}

void agruparArtigoArmazem(ArtigoExpedicao _artigo) {
  String armazem;
  String lote;
  String local;
  // check se o artigo possui armazem valido
  if (_artigo.armazem == null)
    armazem = "@";
  else if (_artigo.armazem.length == 0)
    armazem = "@";
  else
    armazem = _artigo.armazem;

  // check se o artigo possui localizacao valido
  if (_artigo.localizacao == null)
    local = "@";
  else if (_artigo.localizacao.length == 0)
    local = "@";
  else {
    local = _artigo.localizacao;
  }

  // check se o artigo possui localizacao valido
  if (_artigo.lote == null)
    lote = "@";
  else if (_artigo.lote.length == 0)
    lote = "@";
  else
    lote = _artigo.lote;

  String rv = armazem +
      "-" +
      local +
      "-" +
      lote +
      "-" +
      _artigo.quantidadeExpedir.toString();

  if (expedicaoListaArmazemDisplay.containsKey(_artigo.artigo)) {
    if (!expedicaoListaArmazemDisplay[_artigo.artigo].contains(rv))
      expedicaoListaArmazemDisplay[_artigo.artigo].add(rv);
  } else {
    expedicaoListaArmazemDisplay[_artigo.artigo] = new List<String>();
    expedicaoListaArmazemDisplay[_artigo.artigo].add(rv);
  }
}
