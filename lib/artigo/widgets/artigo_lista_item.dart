import 'package:flutter/material.dart';
import 'package:primobile/artigo/bloc/artigo_bloc.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
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

class ArtigoListaItem extends StatelessWidget {
  final Artigo artigo;
  // final ArtigoBloc artigoBloc;
  final bool isSelected;
  final StateSetter setState;
  const ArtigoListaItem(
      {Key key,
      @required this.artigo,
      // this.artigoBloc,
      this.setState,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Conexao.url = Conexao.baseUrl + artigo.artigo;
    TextEditingController txtArtigoQtd = new TextEditingController();
    String msgQtd = '';

    if (this.isSelected == false) {
      listaArtigoSelecionado.clear();
    }

    dynamic artigoCor =
        existeArtigoSelecionado(artigo) == false || this.isSelected == false
            ? Colors.white
            : Colors.red;

    return new Container(
        color: artigoCor,
        child: _ListaTile(
          selected: isSelected,
          onTap: () async {
            if (this.isSelected) {
              if (existeArtigoSelecionado(artigo) == false) {
                try {
                  txtArtigoQtd.text =
                      artigo.quantidade.toStringAsFixed(2).toString();
                  double qtd = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: StatefulBuilder(
                            // You need this, notice the parameters below:
                            builder:
                                (BuildContext context, StateSetter setState) {
                          return Column(
                            // Then, the content of your dialog.
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                  child: Text(artigo.descricao,
                                      style: TextStyle(fontSize: 12))),
                              Center(
                                  child: Text(
                                      'Total Disponivel ' +
                                          artigo.quantidadeStock.toString() +
                                          ' ' +
                                          artigo.unidade,
                                      style: TextStyle(fontSize: 14))),
                              Center(
                                  child:
                                      Text('Quantidade em ' + artigo.unidade)),
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
                              Text(
                                msgQtd,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    elevation: 5.0,
                                    child: Text('Alterar'),
                                    onPressed: () {
                                      try {
                                        if (double.parse(txtArtigoQtd.text) <=
                                                artigo.quantidadeStock &&
                                            double.parse(txtArtigoQtd.text) >
                                                0) {
                                          Navigator.of(context).pop(
                                              double.parse(txtArtigoQtd.text
                                                  .toString()));
                                        } else {
                                          // if (double.parse(txtArtigoQtd.text) >
                                          //     artigo.quantidadeStock) {
                                          //   setState(() {
                                          //     msgQtd = 'Quantidade ' +
                                          //         txtArtigoQtd.text +
                                          //         ' ' +
                                          //         artigo.unidade +
                                          //         ' maior que o Stock disponivel ';
                                          //   });
                                          if (double.parse(txtArtigoQtd.text) <=
                                              0) {
                                            setState(() {
                                              msgQtd =
                                                  'Valido somente valores numericos positivos ';
                                            });
                                          }
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
                    artigo.quantidade = qtd;
                    adicionarArtigo(artigo);
                  } else {
                    artigo.quantidade = 1.0;
                    adicionarArtigo(artigo);
                  }
                } catch (e) {
                  artigo.quantidade = 1.0;
                }
              } else {
                setState(() {
                  adicionarArtigo(artigo);
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
                      title: Center(child: Text(artigo.descricao)),
                      actions: <Widget>[
                        IconButton(
                          icon: new Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    );
                  },
                );
              }),
          title: Text(
            artigo.descricao,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          subtitle: Text(
            "COD: " +
                artigo.artigo +
                "\nQTD: " +
                artigo.quantidadeStock.toString() +
                ' ' +
                artigo.unidade +
                '\n' +
                "PVP: " +
                artigo.preco.toString() +
                ' MT',
            style: TextStyle(color: Colors.blue, fontSize: 11),
          ),
          data: artigo.descricao,
        ));
  }
}
