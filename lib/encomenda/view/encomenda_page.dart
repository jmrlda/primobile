import 'dart:async';
import 'package:primobile/util/util.dart';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
// local
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/database/database.dart';
import 'package:primobile/encomenda/models/models.dart';
import 'package:primobile/encomenda/widgets/lista_tile.dart';
// import 'package:primobile/encomenda/util';
import 'package:primobile/regras_negocio/models/regras_negocio.dart';

// import 'package:primobile/sessao/sessao_api_provider.dart';
// import '../util.dart';

List<Encomenda> encomendas = new List<Encomenda>();
List<EncomendaItem> encomendaItens = new List<EncomendaItem>();
List<RegraPrecoDesconto> regras = new List<RegraPrecoDesconto>();

List<Encomenda> encomendaDuplicado = new List<Encomenda>();
List<Widget> children = List<Widget>();
String filtro;
bool sort = true;

class EncomendaListaPage extends StatefulWidget {
  EncomendaListaPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EncomendaPageState createState() => new _EncomendaPageState();
}

class _EncomendaPageState extends State<EncomendaListaPage> {
  TextEditingController txtPesquisarencomenda = TextEditingController();

  @override
  void initState() {
    super.initState();
    sort = true;

    getEncomenda().then((value) {
      if (this.mounted == true)
        setState(() {
          //  artigos = value;
          if (value != null && value.length > 0)
            encomendas = encomendaDuplicado = value;
          else
            encomendas = null;
        });
    });
    getEncomendaItem().then((value) {
      if (this.mounted == true)
        setState(() {
          encomendaItens = value;
        });
    });
  }

  void filterSearchResults(String query) {
    List<Encomenda> dummySearchList = List<Encomenda>();

    dummySearchList.addAll(encomendaDuplicado);
    if (query.trim().isNotEmpty) {
      List<Encomenda> dummyListData = List<Encomenda>();
      dummySearchList.forEach((item) {
        if (item.cliente.cliente
                .toLowerCase()
                .contains(query.toString().toLowerCase()) ||
            item.encomenda_id
                .toLowerCase()
                .contains(query.toString().toLowerCase())) {
          dummyListData.add(item);
        }
      });
      if (this.mounted == true)
        setState(() {
          encomendas.clear();
          encomendas = dummyListData;
        });
      return;
    } else {
      if (this.mounted == true)
        setState(() {
          encomendas.clear();
          encomendas = dummySearchList;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    getEncomenda().then((value) {
      if (this.mounted == true)
        setState(() {
          //  artigos = value;
          encomendaDuplicado = value;
        });
    });

    return new Scaffold(
      floatingActionButton: listarArtigo(),
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: opcaoAcao,
            itemBuilder: (BuildContext context) {
              return Opcoes.escolha.map((String escolha) {
                return PopupMenuItem<String>(
                  value: escolha,
                  child: Text(escolha),
                );
              }).toList();
            },
          )
        ],
        centerTitle: true,
        title: new Text("Encomendas"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                          )
                        ]),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              hintText: 'Procurar'),
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          controller: txtPesquisarencomenda,
                        ),
                      ),
                    ],
                  ),
                ),
                listarEncomenda()
              ],
            )),
          ],
        ),
      ),
    );
  }

  void opcaoAcao(String opcao) async {
    if (opcao == 'sincronizar') {
      if (this.mounted == true) {
        setState(() {
          encomendas.clear();
        });

        //       encomendaApi.getTodasEncomendas().then((enc) {
        //    // reduntante mas util para informar o estado dos modelos
        //   setState(() {
        //      if (encomendaApi.erro == false ) {
        //          encomendaApi.sincronizado = true;
        //      } else {
        //          encomendaApi.erro = true;
        //      }
        //    });
        // });

        BuildContext dialogContext;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogContext = context;

            return WillPopScope(
              child: AlertDialog(
                title: Center(child: Text('Sincronizando')),
                content: Container(
                    width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator())),
              ),
              onWillPop: () async {
                return false;
              },
            );
          },
        );
//   Timer.periodic(Duration(seconds: 3), (timer) {
//
//     if (encomendaApi.lista.length > 0)
//     setState(() {
//             encomendas = encomendaApi.lista;
//             // if (encomendas.length > 0) {
//               timer?.cancel();
//             // }
//  Navigator.pop(dialogContext);
//              Flushbar(
//                     title: "Informação",
//                     // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
//                     messageText: Text(
//                         'Encomenda sincronizados com sucesso!',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold)),
//                     duration: Duration(seconds: 4),
//                     backgroundColor: Colors.green,
//                   )..show(context);
//     });
//  if (encomendaApi.sincronizado == true) {
//
//                       timer.cancel();
//   Navigator.pop(dialogContext);
//              Flushbar(
//                     title: "Informação",
//                     // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
//                     messageText: Text(
//                         'Encomenda sincronizados com sucesso!',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold)),
//                     duration: Duration(seconds: 4),
//                     backgroundColor: Colors.green,
//                   )..show(context);
//
//                 }
//                 if (encomendaApi.erro == true) {
//                         timer.cancel();
//                   Flushbar(
//                     title: "Atenção",
//                     // message:  "Dispositivo sem conexão WIFI ou Dados Moveis. Por Favor Active para sincronizar dados!",
//                     messageText: Text(
//                         'Ocorreu um erro. Por favor tente novamente!',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold)),
//                     duration: Duration(seconds: 4),
//                     backgroundColor: Colors.red,
//                   )..show(context);
//   Navigator.pop(dialogContext);
//                 }
//
// });

      }
    }
  }

  Widget listarEncomenda() {
    List<Widget> children = List<Widget>();
    if (encomendas != null && encomendas.length > 0) {
      getEncomenda().then((value) {
        if (this.mounted == true) {
          setState(() {
            encomendas = value;
          });
        }
      });

      getEncomendaItem().then((value) {
        if (this.mounted == true) {
          setState(() {
            encomendaItens = value;
          });
        }
      });
    }

    if (encomendas == null || encomendas.length <= 0) {
      return Center(
        child: Text(
          "Nenhuma encomenda encontrada.\n Sincronize os Dados",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      );
    } else if (encomendas.length <= 0) {
      return Column(
        children: [CircularProgressIndicator(), Text("Aguarde")],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      // List encDB = encomendas;
      // SessaoApiProvider.read().then((parsed) async {
      //   Map<String, dynamic> filial = parsed['resultado'];
      //   String protocolo = 'http://';
      //   String host = filial['empresa_filial']['ip'];
      //   String rota = '/api/ImagemUpload/encomenda/';
      //   // var status = await getUrlStatus(url) ;
      //   if ( this.mounted == true)
      //   setState(() {
      //     baseUrl = url = protocolo + host + rota;
      //   });
      // });

      List<Encomenda> li = encomendas; //List<Encomenda> ();
      List<EncomendaItem> item = encomendaItens;
      // li.forEach((enc)
      int pos = 1;
      if (sort == true) {
        li = li.reversed.toList();
      } else {
        li = encomendas;
      }
      for (int i = 0; i < li.length; i++) {
        Encomenda enc = li[i]; // calcularDescontoPreco(li[i]);

        // List<EncomendaItem> liEnc = item.map((e) => e.encomendaPk == enc1.id );
        if (filtro == 'pendente') {
          if (enc.estado != 'pendente') continue;
        } else if (filtro == 'processado') {
          if (enc.estado != 'processado') continue;
        }

        children.add(Padding(
            padding: const EdgeInsets.only(top: 16),
            child: encomenda(context, enc, item, pos)));

        //  sort == true ? pos-- : pos++;
        pos++;
      }

      return Expanded(child: ListView(children: children));
    }
  }
//
//   Widget listaControlo() {
//     return SpeedDial(
//       // both default to 16
//       // marginRight: 18,
//       marginBottom: 20,
//       animatedIcon: AnimatedIcons.menu_close,
//       animatedIconTheme: IconThemeData(size: 22.0),
//       // this is ignored if animatedIcon is non null
//       // child: Icon(Icons.add),
//       visible: true,
//       // If true user is forced to close dial manually
//       // by tapping main button and overlay is not rendered.
//       closeManually: false,
//       curve: Curves.bounceIn,
//       overlayColor: Colors.black,
//       overlayOpacity: 0.5,
//       onOpen: () => print('OPENING DIAL'),
//       onClose: () => print('DIAL CLOSED'),
//       tooltip: 'Speed Dial',
//       heroTag: 'speed-dial-hero-tag',
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       elevation: 8.0,
//       shape: CircleBorder(),
//       children: [
//         SpeedDialChild(
//           child: Icon(Icons.view_list),
//           backgroundColor: Colors.blue,
//           label: 'Todas encomendas',
//           labelStyle: TextStyle(fontSize: 18.0),
//           onTap: ()  {
//                   if ( this.mounted == true)
//             setState(() => filtro = null);
//             },
//         ),
//         SpeedDialChild(
//           child: Icon(Icons.schedule),
//           backgroundColor: Colors.red,
//           label: 'Pendentes',
//           labelStyle: TextStyle(fontSize: 18.0),
//           onTap: ()        {if ( this.mounted == true) setState(() => filtro = 'pendente');},
//         ),
//         SpeedDialChild(
//           child: Icon(Icons.done_all),
//           backgroundColor: Colors.green,
//           label: 'Processadas',
//           labelStyle: TextStyle(fontSize: 18.0),
//           onTap: () {      if ( this.mounted == true) setState(() => filtro = 'processado');},
//         ),
//         SpeedDialChild(
//           child: Icon(Icons.sort),
//           backgroundColor: Colors.yellow,
//           label: sort == false ? 'Modo Descendente' : 'Modo Ascendente',
//           labelStyle: TextStyle(fontSize: 18.0),
//           onTap: ()     {  if ( this.mounted == true) setState(() => sort = !sort);},
//         ),
//       ],
//     );
//   }
// }

  Widget listarArtigo() {
    if (encomendas == null || encomendas.length <= 0) {
      return Container(
        child: ListTile(
          key: null,
          title: Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Encomenda não encontrado",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    } else {
      return Scrollbar(
        isAlwaysShown: true,
        child: ListView.builder(
          itemCount: encomendas != null ? encomendas.length : 0,
          itemBuilder: (context, index) {
            Encomenda encomenda = encomendas[index];
            url = baseUrl + encomenda.encomenda_id.replaceAll("/", "_");

            return Container(
                child: ExpansionTile(
              leading: GestureDetector(
                  child: ClipOval(child: Icon(Icons.error)
                      //      CachedNetworkImage(
                      //   width: 45,
                      //   height: 45,
                      //   fit: BoxFit.cover,
                      //   imageUrl: url,
                      //   placeholder: (context, url) => CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // )

                      ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text("Alterar Imagem")),
                          // memory(artigos[index].imagemBuffer as Uint8List, width: 350, height: 250)
                          content: CachedNetworkImage(
                            imageUrl: baseUrl +
                                encomenda.encomenda_id.replaceAll("/", "_"),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),

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
                encomenda.cliente.cliente.toString(),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(
              //   "teste" + encomenda.artigos.length.toString(),
              //   style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              // ),
            ));
          },
        ),
      );
    }
  }

  Future teste() async {
    var res = await DBProvider.db.getTodosArtigos();

    return res;
  }

  Future<List<Encomenda>> getEncomenda() async {
    // List<Encomenda> res;
    // try {
    //   res = await DBProvider.db.getTodasEncomendas();
    //   for (int i = 0; i < res.length; i++) {
    //     res[i].regrasPreco = await getEncomendaRegra(res[i].encomenda_id);
    //   }
    // } catch (err) {
    //   res = null;
    // }

    // return res;
    //
    return null;
  }

  Future<List<EncomendaItem>> getEncomendaItem() async {
    List<EncomendaItem> res;
    try {
      res = await DBProvider.db.getTodasEncomendaItens();
    } catch (err) {
      res = null;
    }
    return res;
  }

  Future<List<RegraPrecoDesconto>> getEncomendaRegra(String encomenda) async {
    List<RegraPrecoDesconto> res;

    try {
      res = await DBProvider.db.getEncomendaRegra(encomenda);
      //res1 = await DBProvider.db.getEncomendaRegra1();

    } catch (err) {
      res = null;
    }
    return res;
  }

// metodos uteis

  ExpansionTile encomendaItem(
      BuildContext context, Encomenda enc, List<EncomendaItem> itens, pos) {
    int count = 0;
    double totalValor = 0.0;
    List<DataTable> encomendaItens = List<DataTable>();

    encomendaItens.add(DataTable(
      columns: [
        DataColumn(
            label: Text("Artigo",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                ))),
        DataColumn(
            label: Text("Qtd.",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                ))),
        DataColumn(
            label: Text("P.Unit",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                ))),
        DataColumn(
            label: Text("Subtotal",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                ))),
      ],
      rows: [],
    ));

    itens.forEach((element) {
      EncomendaItem e = element;
      if (e.encomendaPk.toString() == enc.id.toString()) {
        totalValor += e.valorTotal;
        count++;
        encomendaItens.elementAt(0).rows.add(DataRow(cells: [
              DataCell(Text(e?.artigoPk.toString())),
              DataCell(Text(e.quantidade.toString())),
              DataCell(Text(e.valorUnit.toString())),
              DataCell(Text((e.valorUnit * e.quantidade).toStringAsFixed(2))),
            ]));
      }
    });

    MaterialColor cor = enc.estado == "pendente" ? Colors.red : Colors.blue;
    url = baseUrl + (enc.encomenda_id.replaceAll("/", "_"));
    return ExpansionTile(
      title: Padding(
        padding: EdgeInsets.only(top: 15, left: 16, right: 16),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.,
          children: <Widget>[
            GestureDetector(
                child: ClipOval(
                    child: Icon(
                  Icons.gesture,
                  size: 45,
                )
                    //     child: CachedNetworkImage(
                    //   width: 45,
                    //   height: 45,
                    //   fit: BoxFit.cover,
                    //   imageUrl: baseUrl + (enc.encomenda_id.replaceAll("/", "_")),
                    //   placeholder: (context, url) => CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // )
                    ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text(enc.encomenda_id)),
                        // memory(artigos[index].imagemBuffer as Uint8List, width: 350, height: 250)
                        content: CachedNetworkImage(
                          imageUrl:
                              baseUrl + enc.encomenda_id.replaceAll("/", "_"),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),

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
            Padding(
              padding: EdgeInsets.only(left: 55),
              child: Text(enc.encomenda_id,
                  style: TextStyle(
                      color: cor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
      subtitle: Column(
        children: [
          Divider(),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Center(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(count > 1 ? count.toString() + " Artigos" : "1 Artigo",
                        style: TextStyle(color: cor, fontSize: 14)),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                          double.parse(enc.valorTotal.toStringAsFixed(2))
                                  .toString() +
                              "MTN",
                          style: TextStyle(color: cor, fontSize: 13)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(enc.cliente.cliente,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: cor, fontSize: 13)),
                    ),
                  ],
                ),
              )),
        ],
      ),
      children: encomendaItens,
    );
  }

// Future<void> _ackAlert(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         // title: Text('Not in stock'),
//         content: Container(
//           height: 250,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Icon(
//                 Icons.block,
//                 size: 180,
//                 color: Colors.blue,
//               ),
//               Text(
//                 'Tem a certeza que\n deseja remover ?',
//                 style: TextStyle(color: Colors.blue),
//               )
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             shape: CircleBorder(),
//             color: Colors.blue[100],
//             textColor: Colors.white,
//             disabledColor: Colors.grey,
//             disabledTextColor: Colors.black,
//             padding: EdgeInsets.all(15.0),
//             splashColor: Colors.blueAccent,
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               "Nao",
//               style: TextStyle(fontSize: 18.0, color: Colors.blue),
//             ),
//           ),
//           FlatButton(
//             shape: CircleBorder(),
//             color: Colors.red,
//             textColor: Colors.white,
//             disabledColor: Colors.grey,
//             disabledTextColor: Colors.black,
//             padding: EdgeInsets.all(15.0),
//             splashColor: Colors.blueAccent,
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               "Sim",
//               style: TextStyle(fontSize: 18.0),
//             ),
//           )
//         ],
//       );
//     },
//   );
// }

  Encomenda calcularDescontoPreco(Encomenda encomenda) {
    RegraPrecoDesconto regraPreco;

    for (int i = 0; i < encomenda.artigos.length; i++) {
      Artigo artigo = encomenda.artigos[i];

      for (int j = 0; j < encomenda.artigos.length; j++) {
        if (encomenda.regrasPreco[j].artigo == artigo.artigo)
          regraPreco = encomenda.regrasPreco[i];
      }

      //getRegras(artigo.artigo);
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
      }

      // artigo.pvp1 = artigo.preco; // alterar o preco geral para pvp1
      // encomenda.artigos[i] = artigo;
      //  try {
      //       encomenda.regrasPreco.add(regraPreco);
      //      encomenda.regrasPreco_json.add(jsonEncode(regraPreco.toMap()));

      //  }catch ( err ) {
      //    print('[getDescontoPreco] Erro: ' + err.toString());
      //  }

    }
    encomenda.valorTotal = recalcularEncomendatotal(encomenda.artigos);
    return encomenda;
  }

  double recalcularEncomendatotal(List<Artigo> artigos) {
    double total = 0.0;
    for (int i = 0; i < artigos.length; i++) {
      total += artigos[i].preco * artigos[i].quantidade;
    }

    return total;
  }
}

class Opcoes {
  static const String Sincronizar = 'sincronizar';

  static const List<String> escolha = <String>[
    Sincronizar,
  ];
}
