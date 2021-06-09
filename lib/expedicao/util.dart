import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

List<DataRow> buildInventarioDataRow(String artigo, {ArtigoExpedicao artigoObj}) {
  List<DataRow> listaDataRow = List<DataRow>();
  String armazem = "";
  for (int i = 0; i < expedicaoListaArmazemDisplay[artigo].length; i++) {
    armazem = expedicaoListaArmazemDisplay[artigo][i];

    listaDataRow.add(DataRow(
      cells: <DataCell>[
        DataCell(
          Text(armazem.split("-")[0], style: TextStyle(fontSize: 11)),
        ),
        DataCell(Text(armazem.split("-")[1], style: TextStyle(fontSize: 11))),
        DataCell(Text(armazem.split("-")[2], style: TextStyle(fontSize: 11))),
        DataCell(Text(artigoObj != null ? artigoObj.quantidadePendente.toString() : "0", style: TextStyle(fontSize: 11))),
        DataCell(TextFieldCustom(artigo, armazem)),
      ],
    ));
  }
  return listaDataRow;
}

// Atribuir quatidade ao artigo que tenha mesmo armazem, localizacao e lote.
void setArtigQuantidadeByArmazem(
    String artigo, double quantidade, String artigoKey) {
  // inventarioListaArmazemDisplay[artigo];
  bool found = false;
  for (int i = 0; i < expedicaoListaArmazemDisplay[artigo].length; i++) {
    String armazem = expedicaoListaArmazemDisplay[artigo][i];
    List<String> arm = armazem.split("-");
    String _armazem = arm[0] == "@" ? "" : arm[0];
    String _loc = arm[1] == "@" ? "" : arm[1];
    String _lote = arm[2] == "@" ? "" : arm[2];

    for (int j = 0; j < lista_artigo_expedicao.length; j++) {
      ArtigoExpedicao _artInv = new ArtigoExpedicao();
      _artInv = lista_artigo_expedicao[j];
      if (_artInv.artigo == artigo &&
          _artInv.armazem == _armazem &&
          _artInv.localizacao == _loc &&
          _artInv.lote == _lote &&
          artigoKey.contains(armazem)) {
        lista_artigo_expedicao[j].quantidadeExpedir = quantidade;
        found = true;
        break;
      }
    }
    if (found) break;
// lista_artigo_inventario
  }
}

Widget TextFieldCustom(String artigo, String armazem) {
  // final GlobalKey linhaInvKey = GlobalKey(debugLabel: armazem);
  Key linhaInvKey = new Key(armazem);
  TextEditingController _controller = new TextEditingController();
  _controller.text = armazem.split("-")[3];
  return TextField(
    key: linhaInvKey,
    keyboardType: TextInputType.number,
    autofocus: false,
    style: TextStyle(fontSize: 13),
    textAlign: TextAlign.right,
    controller: _controller,
    onChanged: (value) {
      try {
        print(linhaInvKey.toString().contains(armazem));
        if (double.parse(_controller.text) > 0) {
          setArtigQuantidadeByArmazem(
              artigo, double.parse(_controller.text), linhaInvKey.toString());
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
