import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/expedicao/util.dart';
import 'package:primobile/rececao/bloc/bloc.dart';
import 'package:primobile/rececao/models/models.dart';

List<Rececao> listaRececaoSelecionado = List<Rececao>();
List<Rececao> listaRececaoDisplay = List<Rececao>();
RececaoBloc rececaoBloc;
TextEditingController rececaoPesquisarController = TextEditingController();

List<ArtigoRececao> listaArtigoRececaoDisplayFiltro = List<ArtigoRececao>();
List<ArtigoRececao> listaArtigoRececaoDisplay = List<ArtigoRececao>();
List<ArtigoRececao> lista_artigo_rececao = List<ArtigoRececao>();

Map<String, List<String>> rececaoListaArmazemDisplay =
    Map<String, List<String>>();

List<DataRow> buildInventarioDataRow(ArtigoRececao artigoObj) {
  String artigo = artigoObj.artigo;
  List<DataRow> listaDataRow = List<DataRow>();

  Artigo _artigo = Artigo.getArtigo(artigoListaDisplayFiltro, artigo);

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
        DataCell(TextFieldCustom(artigoObj, i, 0)),
        DataCell(TextFieldCustom(artigoObj, i, 1)),
      ],
    ));
  }
  return listaDataRow;
}

// Atribuir quatidade ao artigo que tenha mesmo armazem, localizacao e lote.
void setArtigQuantidadeByArmazem(
    ArtigoRececao artigoObj, double quantidade, int posicao, int type) {
  String artigo = artigoObj.artigo;
  // inventarioListaArmazemDisplay[artigo];
  bool found = false;

  for (int j = 0; j < listaArtigoRececaoDisplayFiltro.length; j++) {
    ArtigoRececao _artInv = new ArtigoRececao();
    _artInv = listaArtigoRececaoDisplayFiltro[j];
    int i = 0;
    if (artigoObj.artigo == listaArtigoRececaoDisplayFiltro[j].artigo) {
      // lista_artigo_expedicao[j].artigoObj. = quantidade;
      // element.quantidadeExpedir = quantidade;
      if (type == 0) {
        listaArtigoRececaoDisplayFiltro[j]
            .artigoObj
            .artigoArmazem[posicao]
            .quantidadeRecebido = quantidade;
      } else {
        listaArtigoRececaoDisplayFiltro[j]
            .artigoObj
            .artigoArmazem[posicao]
            .quantidadeRejeitada = quantidade;
      }

      found = true;
      break;
    }
  }

//   for (int i = 0; i < rececaoListaArmazemDisplay[artigo].length; i++) {
//     String armazem = rececaoListaArmazemDisplay[artigo][i];
//     List<String> arm = armazem.split("-");
//     String _armazem = arm[0] == "@" ? "" : arm[0];
//     String _loc = arm[1] == "@" ? "" : arm[1];
//     String _lote = arm[2] == "@" ? "" : arm[2];

//     for (int j = 0; j < lista_artigo_rececao.length; j++) {
//       ArtigoRececao _artInv = new ArtigoRececao();
//       _artInv = lista_artigo_rececao[j];
//       if (_artInv.artigo == artigo &&
//           _artInv.armazem == _armazem &&
//           _artInv.localizacao == _loc &&
//           _artInv.lote == _lote &&
//           artigoKey.contains(armazem)) {
//         if (type == 0) {
//           lista_artigo_rececao[j].quantidadeRecebida = quantidade;
//         } else {
//           lista_artigo_rececao[j].quantidadeRejeitada = quantidade;
//         }

//         found = true;
//         break;
//       }
//     }
//     if (found) break;
// // lista_artigo_inventario
//   }
}

Widget TextFieldCustom(ArtigoRececao artigoRececao, int posicao, int type) {
  // final GlobalKey linhaInvKey = GlobalKey(debugLabel: armazem);
  ArtigoArmazem _artigoArmazem = artigoRececao.artigoObj.artigoArmazem[posicao];

  Key linhaInvKey = new Key(_artigoArmazem.artigoArmazemId() + type.toString());
  TextEditingController _controller = new TextEditingController();

  _controller.text = type == 0
      ? _artigoArmazem.quantidadeRecebido.toString()
      : _artigoArmazem.quantidadeRejeitada.toString();
  return TextField(
    key: linhaInvKey,
    keyboardType: TextInputType.number,
    autofocus: false,
    style: TextStyle(fontSize: 13),
    textAlign: TextAlign.right,
    controller: _controller,
    onChanged: (value) {
      try {
        if (double.tryParse(_controller.text) > 0) {
          setArtigQuantidadeByArmazem(
              artigoRececao, double.parse(_controller.text), posicao, type);
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

void agruparArtigoArmazem(ArtigoRececao _artigo) {
  String armazem;
  String lote;
  String local;
  GlobalKey gkey = new GlobalKey();
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
      _artigo.quantidadeRecebida.toString() +
      "-" +
      _artigo.quantidadeRejeitada.toString() +
      "-" +
      gkey.toString();

  if (rececaoListaArmazemDisplay.containsKey(_artigo.artigo)) {
    if (!rececaoListaArmazemDisplay[_artigo.artigo].contains(rv))
      rececaoListaArmazemDisplay[_artigo.artigo].add(rv);
  } else {
    rececaoListaArmazemDisplay[_artigo.artigo] = new List<String>();
    rececaoListaArmazemDisplay[_artigo.artigo].add(rv);
  }
}
