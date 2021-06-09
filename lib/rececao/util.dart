import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

List<DataRow> buildInventarioDataRow(String artigo) {
  List<DataRow> listaDataRow = List<DataRow>();
  String armazem = "";
  for (int i = 0; i < rececaoListaArmazemDisplay[artigo].length; i++) {
    armazem = rececaoListaArmazemDisplay[artigo][i];

    listaDataRow.add(DataRow(
      cells: <DataCell>[
        DataCell(
          Text(armazem.split("-")[0], style: TextStyle(fontSize: 11)),
        ),
        DataCell(Text(armazem.split("-")[1], style: TextStyle(fontSize: 11))),
        DataCell(Text(armazem.split("-")[2], style: TextStyle(fontSize: 11))),
        DataCell(TextFieldCustom(artigo, armazem, 0)),
        DataCell(TextFieldCustom(artigo, armazem, 1)),
      ],
    ));
  }
  return listaDataRow;
}

// Atribuir quatidade ao artigo que tenha mesmo armazem, localizacao e lote.
void setArtigQuantidadeByArmazem(
    String artigo, double quantidade, String artigoKey, int type) {
  // inventarioListaArmazemDisplay[artigo];
  bool found = false;
  for (int i = 0; i < rececaoListaArmazemDisplay[artigo].length; i++) {
    String armazem = rececaoListaArmazemDisplay[artigo][i];
    List<String> arm = armazem.split("-");
    String _armazem = arm[0] == "@" ? "" : arm[0];
    String _loc = arm[1] == "@" ? "" : arm[1];
    String _lote = arm[2] == "@" ? "" : arm[2];

    for (int j = 0; j < lista_artigo_rececao.length; j++) {
      ArtigoRececao _artInv = new ArtigoRececao();
      _artInv = lista_artigo_rececao[j];
      if (_artInv.artigo == artigo &&
          _artInv.armazem == _armazem &&
          _artInv.localizacao == _loc &&
          _artInv.lote == _lote &&
          artigoKey.contains(armazem)) {
        if (type == 0) {
          lista_artigo_rececao[j].quantidadeRecebida = quantidade;
        } else {
          lista_artigo_rececao[j].quantidadeRejeitada = quantidade;
        }

        found = true;
        break;
      }
    }
    if (found) break;
// lista_artigo_inventario
  }
}

Widget TextFieldCustom(String artigo, String armazem, int type) {
  // final GlobalKey linhaInvKey = GlobalKey(debugLabel: armazem);
  Key linhaInvKey = new Key(armazem);
  TextEditingController _controller = new TextEditingController();

  _controller.text = type == 0 ? armazem.split("-")[3] : armazem.split("-")[4];
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
        if (double.tryParse(_controller.text) > 0) {
          setArtigQuantidadeByArmazem(artigo, double.parse(_controller.text),
              linhaInvKey.toString(), type);
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
