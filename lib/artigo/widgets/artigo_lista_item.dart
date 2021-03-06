import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/artigo/view/view.dart';
import 'package:primobile/util/util.dart';

class _ListaTile extends ListTile {
  _ListaTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.isThreeLine = false,
      this.dense,
      this.contentPadding,
      this.enabled = true,
      this.onTap,
      this.onLongPress,
      this.selected = false,
      this.data = ""})
      : super(
            key: key,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            isThreeLine: isThreeLine,
            dense: dense,
            contentPadding: contentPadding,
            enabled: enabled,
            onTap: onTap,
            onLongPress: onLongPress,
            selected: selected);
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool selected;
  final String data;

  String getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

class ArtigoListaItem extends StatefulWidget {
  final Artigo artigo;
  // final ArtigoBloc artigoBloc;
  final bool isSelected;
  const ArtigoListaItem(
      {Key key,
      @required this.artigo,
      // this.artigoBloc,
      this.isSelected = false})
      : super(key: key);

  @override
  _ArtigoListaItemState createState() => _ArtigoListaItemState();
}

class _ArtigoListaItemState extends State<ArtigoListaItem> {
  @override
  Widget build(BuildContext context) {
    Conexao.url = Conexao.baseUrl + widget.artigo.artigo;
    TextEditingController txtArtigoQtd = new TextEditingController();
    String msgQtd = '';

    if (this.widget.isSelected == false) {
      listaArtigoSelecionado.clear();
    }

    dynamic artigoCor = existeArtigoSelecionado(widget.artigo) == false ||
            this.widget.isSelected == false
        ? Colors.white
        : Colors.red;

    return new Container(
        color: artigoCor,
        child: _ListaTile(
          selected: widget.isSelected,
          onTap: () async {
            if (this.widget.isSelected) {
              if (existeArtigoSelecionado(widget.artigo) == false) {
                try {
                  txtArtigoQtd.text = "1.00";
                  // widget.artigo.quantidade.toStringAsFixed(2).toString();
                  double qtd = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        content: StatefulBuilder(
                            // You need this, notice the parameters below:
                            builder:
                                (BuildContext context, StateSetter setState) {
                          return Column(
                            // Then, the content of your dialog.
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                  child: Text(widget.artigo.descricao,
                                      style: TextStyle(fontSize: 12))),
                              Center(
                                  child: Text(
                                      'Quantidade em ' + widget.artigo.unidade,
                                      style: TextStyle(fontSize: 12))),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: txtArtigoQtd,
                                autofocus: false,
                                onTap: () {
                                  txtArtigoQtd.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          txtArtigoQtd.value.text.length);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(msgQtd,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    elevation: 5.0,
                                    child: Text('Alterar'),
                                    onPressed: () {
                                      try {
                                        if (double.parse(txtArtigoQtd.text) >
                                            0) {
                                          Navigator.of(context).pop(
                                              double.parse(txtArtigoQtd.text
                                                  .toString()));
                                        } else {
                                          setState(() {
                                            msgQtd =
                                                'Valido somente valores numericos positivos ';
                                          });
                                        }
                                      } catch (err) {
                                        setState(() {
                                          msgQtd =
                                              'Valido somente valores numericos e positivos ';
                                        });
                                      }
                                    },
                                  ))
                            ],
                          );
                        }),
                        actions: null,
                      );
                    },
                  );

                  if (qtd != null) {
                    widget.artigo.quantidade = qtd;
                    adicionarArtigo(widget.artigo);

                    setState(() {
                      listaArtigoSelecionado = listaArtigoSelecionado;
                    });
                  } else {
                    widget.artigo.quantidade = 1.0;
                    adicionarArtigo(widget.artigo);

                    setState(() {
                      listaArtigoSelecionado = listaArtigoSelecionado;
                    });
                  }
                } catch (e) {
                  widget.artigo.quantidade = 1.0;
                }
              } else {
                setState(() {
                  adicionarArtigo(widget.artigo);
                  artigoBloc..add(ArtigoFetched());
                });
              }
            }
          },
          leading: GestureDetector(
              child: ClipOval(child: networkIconImage(Conexao.url)),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Container(
                        child: new Center(
                            child: Text(
                          widget.artigo.artigo +
                              " - " +
                              widget.artigo.descricao,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        )),
                      ),
                      content: new Scrollbar(
                          isAlwaysShown: true,
                          child: new ConstrainedBox(
                              constraints: new BoxConstraints(
                                maxHeight: 250.0,
                              ),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columnSpacing: 10.0,
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Armaz.',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 11),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Loc.',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 11),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Lote',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 11),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Stock',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 11),
                                        ),
                                      ),
                                    ],
                                    rows: buildArtigoArmazemDataRow(
                                        widget.artigo),
                                  )))),
                      actions: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Fechar'),
                        )
                      ],
                    );
                  },
                );
              }),
          title: Text(
            widget.artigo.descricao,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11),
          ),
          subtitle: Text(
            "COD: " +
                widget.artigo.artigo +
                " -- " +
                widget.artigo.codigoBarra.toString() +
                '\n' +
                "PVP: " +
                widget.artigo.pvp1.toString() +
                ' MT',
            style: TextStyle(color: Colors.blue, fontSize: 11),
          ),
          data: widget.artigo.descricao,
        ));
  }
}
