import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/encomenda/models/models.dart';
import 'package:primobile/regras_negocio/models/regras_negocio.dart';

// import 'package:primobile/artigo/artigo_modelo.dart';
// import 'package:primobile/encomenda/encomenda_api_provider.dart';
// import 'package:primobile/encomenda/regraPrecoDesconto_modelo.dart';
// import 'package:primobile/sessao/sessao_api_provider.dart';

List<Artigo> artigoLista;
List<Artigo> artigosDuplicado = new List<Artigo>();
String baseUrl = "";
String url = "";
List<dynamic> listaRegra;
Object encomendaApi = null; //EncomendaApiProvider();

// Encomenda encomenda_data;
// ignore: must_be_immutable
class EncomendaListaConfirmacaoPage extends StatefulWidget {
  Encomenda encomenda;

  EncomendaListaConfirmacaoPage({Key key, this.encomenda}) : super(key: key);
  // final String title;

  @override
  _EncomendaListaConfirmacaoPageState createState() =>
      new _EncomendaListaConfirmacaoPageState();
}

class _EncomendaListaConfirmacaoPageState
    extends State<EncomendaListaConfirmacaoPage> {
  TextEditingController editingController = TextEditingController();

  List<Artigo> listaArtigoSelecionado = List<Artigo>();

  var duplicateItems;

  var items = List<_ListaTile>();

  @override
  void initState() {
    super.initState();

    //    SessaoApiProvider.readSession().then((parsed) async {
    //      Map<String, dynamic> filial = parsed['resultado'];
    //      String protocolo = 'http://';
    //      String host = filial['empresa_filial']['ip'];
    //      String rota = '/api/ImagemUpload/artigo/';
    //      // var status = await getUrlStatus(url) ;
    //        listaRegra = null;
    //
    //
    // encomendaApi.postBuscarDesconto(widget.encomenda).then((response) {
    //      setState(() {
    //        listaRegra = jsonDecode(response.body);
    //
    //           widget.encomenda = getDescontoPreco(widget.encomenda);
    //
    //                baseUrl = url = protocolo + host + rota;
    //      });
    //      print(listaRegra);
    //    });
    //      // setState(() {
    //      // });
    //    });
  }

  // metodo para busca de artigos na lista
  void filterSearchResults(String query) {
    List<Artigo> dummySearchList = List<Artigo>();

    dummySearchList.addAll(artigosDuplicado);
    if (query.trim().isNotEmpty) {
      List<Artigo> dummyListData = List<Artigo>();
      dummySearchList.forEach((item) {
        if (item.descricao.toLowerCase().contains(query.toString()) ||
            item.artigo.toLowerCase().contains(query.toString())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        artigoLista.clear();
        artigoLista = dummyListData;
      });
      return;
    } else {
      setState(() {
        artigoLista.clear();
        artigoLista = dummySearchList;
      });
    }
  }

  var color = Colors.white;

  @override
  Widget build(BuildContext context) {
    widget.encomenda = ModalRoute.of(context).settings.arguments;
    // widget.encomenda.valorTotal = 0;
    //  if ( listaRegra.length - 1 == index){
    //             // encomenda_data = widget.encomenda;
    //           // setState(() {
    //             widget.encomenda.valorTotal = recalcularEncomendatotal(widget.encomenda.artigos);
    //           // });
    //           }
    setState(() {
      artigosDuplicado = widget.encomenda.artigos;
      artigoLista = widget.encomenda.artigos;
    });

    return new Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            color: Colors.red,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.redAccent,
            onPressed: () {
              Navigator.of(context)
                  .pop({"estado": false, "resultado": widget.encomenda});
            },
            child: Text("Voltar"),
          ),
          FlatButton(
              color: Colors.green,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.greenAccent,
              onPressed: () {
                // if (widget.encomenda.valorTotal > 0)
                Navigator.of(context)
                    .pop({"estado": true, "resultado": widget.encomenda});
              },
              child: Text("Finalizar"))
        ],
      ),
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: new Text("Resumo Encomenda"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pop({"estado": false, "resultado": widget.encomenda}),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 5),
            height: 120,
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                // espaco(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cliente:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.encomenda.cliente.nome,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                // espaco(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Encomenda:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.encomenda.encomenda_id,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total Artigo:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.encomenda.artigos.length.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total Valor:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    // (widget.encomenda.valorTotal <= 0)
                    //     ? Text('Processando ...',
                    //         style: TextStyle(
                    //             fontSize: 16,
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold))
                    //     :

                    Text(
                      widget.encomenda.valorTotal.toStringAsFixed(2).toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(child: listaArtigo()),
        ],
      ),
    );
  }

  Widget listaArtigo() {
    if (listaRegra != null && listaRegra.length <= 0) {
      return Column(
        children: [CircularProgressIndicator(), Text("Aguarde")],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return Scrollbar(
        isAlwaysShown: false,
        child: ListView.builder(
          itemCount: artigoLista.length,
          itemBuilder: (context, index) {
            Artigo artigo = artigoLista[index];

            url = baseUrl + artigo.artigo;

            return new Container(
              child: _ListaTile(
                leading: GestureDetector(
                    child: ClipOval(child: Icon(Icons.error)

                        // CachedNetworkImage(
                        //   width: 45,
                        //   height: 45,
                        //   fit: BoxFit.cover,
                        //   imageUrl: url,
                        //   placeholder: (context, url) =>
                        //       CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                        // ),
                        ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: Text(artigo.descricao)),
                            // memory(artigos[index].imagemBuffer as Uint8List, width: 350, height: 250)
                            content: Icon(Icons.error),

                            //  CachedNetworkImage(
                            //   imageUrl: baseUrl + artigo.artigo,
                            //   placeholder: (context, url) =>
                            //       CircularProgressIndicator(),
                            //   errorWidget: (context, url, error) =>
                            //       Icon(Icons.error),
                            // ),

                            actions: <Widget>[
                              IconButton(
                                icon: new Icon(Icons.close),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              )
                            ],
                          );
                        },
                      );
                    }),
                title: Text(
                  artigo.descricao,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                subtitle: Text(
                  "P.Unit: " +
                      artigo.preco.toStringAsFixed(2).toString() +
                      ' MT'
                          ' ' +
                      "Qtd: " +
                      artigo.quantidade.toString() +
                      ' ' +
                      "Subtotal: " +
                      (artigo.preco * artigo.quantidade)
                          .toStringAsFixed(2)
                          .toString() +
                      ' MT',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
                data: artigo.descricao,
              ),
            );
          },
        ),
      );
    }
  }
}

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

RegraPrecoDesconto getRegras(String artigo) {
  if (listaRegra.length > 0) {
    for (int i = 0; i < listaRegra.length; i++) {
      RegraPrecoDesconto regra = RegraPrecoDesconto.fromJson(listaRegra[i]);

      if (artigo == regra.artigo) {
        return regra;
      }
    }
  }
  return RegraPrecoDesconto();
}

double recalcularEncomendatotal(List<Artigo> artigos) {
  double total = 0.0;
  for (int i = 0; i < artigos.length; i++) {
    total += artigos[i].preco * artigos[i].quantidade;
  }

  return total;
}

Encomenda getDescontoPreco(Encomenda encomenda) {
  for (int i = 0; i < encomenda.artigos.length; i++) {
    Artigo artigo = encomenda.artigos[i];

    if (listaRegra != null && listaRegra.length > 0) {
      RegraPrecoDesconto regraPreco = getRegras(artigo.artigo);
      double percentagem = regraPreco.desconto;
      double desconto = percentagem > 0 ? percentagem / 100 : 0;

      if (regraPreco.regra == RegraPrecoDesconto.REGRA_ARTIGO) {
        if (regraPreco.preco > 0)
          artigo.preco = regraPreco.preco;
        else
          artigo.preco = artigo.pvp1;

        // regra cliente
      } else if (regraPreco.regra == RegraPrecoDesconto.REGRA_CLIENTE) {
        if (regraPreco.tipoPreco == 0) {
          artigo.preco = artigo.pvp1 - (artigo.pvp1 * desconto);
        } else if (regraPreco.tipoPreco == 1) {
          //  verificar o tipo de preco que o cliente possui.
          //  se o seu preco for menor ou igual a zero.
          //  atribuir o preco padrao do artigo.
          if (artigo.pvp2 > 0) {
            artigo.preco = artigo.pvp2 - (artigo.pvp2 * desconto);
          } else {
            artigo.preco = artigo.pvp1 - (artigo.pvp1 * desconto);
          }
        } else if (regraPreco.tipoPreco == 2) {
          if (artigo.pvp3 > 0) {
            artigo.preco = artigo.pvp3 - (artigo.pvp3 * desconto);
          } else {
            artigo.preco = artigo.pvp1 - (artigo.pvp1 * desconto);
          }
        }
        if (regraPreco.tipoPreco == 3) {
          if (artigo.pvp4 > 0) {
            artigo.preco = artigo.pvp4 - (artigo.pvp4 * desconto);
          } else {
            artigo.preco = artigo.pvp1 - (artigo.pvp1 * desconto);
          }
        } else if (regraPreco.tipoPreco == 4) {
          if (artigo.pvp5 > 0) {
            artigo.preco = artigo.pvp5 - (artigo.pvp5 * desconto);
          } else {
            artigo.preco = artigo.pvp1 - (artigo.pvp1 * desconto);
          }
        } else if (regraPreco.tipoPreco == 5) {
          if (artigo.pvp6 > 0) {
            artigo.preco = artigo.pvp6 - (artigo.pvp6 * desconto);
          } else {
            artigo.preco = artigo.pvp1 - (artigo.pvp1 * desconto);
          }
        }
      } else if (regraPreco.regra == RegraPrecoDesconto.REGRA_CLIENTE_ARTIGO) {
        if (regraPreco.preco > 0)
          artigo.preco = regraPreco.preco;
        else
          artigo.preco = artigo.pvp1;
      } else {
        // teste
      }

      // artigo.pvp1 = artigo.preco; // alterar o preco geral para pvp1
      encomenda.artigos[i] = artigo;
      try {
        encomenda.regrasPreco.add(regraPreco);
        encomenda.regrasPreco_json.add(jsonEncode(regraPreco.toJson()));
      } catch (err) {
        print('[getDescontoPreco] Erro: ' + err.toString());
      }
    }
  }
  encomenda.valorTotal = recalcularEncomendatotal(encomenda.artigos);
  return encomenda;
}
