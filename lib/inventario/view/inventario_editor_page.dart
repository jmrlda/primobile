import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/inventario/models/inventario.dart';
import 'package:primobile/inventario/models/models.dart';
import 'package:primobile/inventario/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/util/util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

BuildContext contexto;
http.Client httpClient = http.Client();

ScrollController _scrollController = new ScrollController();
int index = 0;
int idx = 0;

class InventarioEditorPage extends StatefulWidget {
  InventarioEditorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InventarioEditorPageState createState() => new _InventarioEditorPageState();
}

class _InventarioEditorPageState extends State<InventarioEditorPage> {
  TextEditingController txtClienteController = TextEditingController();
  TextEditingController txtQtdArtigoController = TextEditingController();
  BuildContext context;
  List<Widget> items = List<Widget>();
  final List<dynamic> encomendaItens = <dynamic>[
    // encomendaItemVazio(),
  ];
  // List<GlobalKey> posicao;
  List<bool> posicao;

  double mercadServicValor = 0.0;
  double noIva = 0.0;
  double ivaTotal = 0.0;
  double subtotal = 0.0;
  double totalVenda = 0.0;
  Inventario inventario = Inventario();
  double iva = 17.0;
  List<Artigo> artigos = new List<Artigo>();
  List artigoJson = List();
  bool erroEncomenda = false;
  String inventarioNumDoc = "Selecionar";
  bool evtPesquisar = false;
  final GlobalKey inventarioPesquisaKey = GlobalKey();
  String armazem = "";

  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    // items.addAll(encomendaItens);

    super.initState();

    inventarioListaArmazemDisplay.clear();

    try {
      updateConnection(() {
        setState(() {
          PRIMARY_COLOR = CONEXAO_ON_COLOR;
        });
      }, () {
        setState(() {
          PRIMARY_COLOR = CONEXAO_OFF_COLOR;
        });
      });
    } catch (e) {}
  }

  void update(cb) {
    setState(() {
      cb();
    });
  }

  Future<bool> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Atenção')),
            content: Text('Deseja Cancelar Expedição ?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  GlobalKey stickyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    index = 0;
    idx = 0;
    contexto = context;

    return WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: PRIMARY_COLOR,
          centerTitle: true,
          title: togglePesquisa(),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              if (artigos != null && artigos.length > 0) {
                createAlertDialog(context).then((sair) {
                  if (sair == true) {
                    Navigator.of(context).pop();
                  }
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Container(
          color: Colors.blue[400],
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue[900], // fromRGBO(7, 89, 250, 100)
                  // gradient: LinearGradient(
                  //     // begin: ``
                  //     colors: [Colors.blueAccent, Colors.blueAccent]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    espaco(),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 80,
                      padding: EdgeInsets.only(
                          top: 5, left: 16, right: 16, bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              // blurRadius: 5
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // espaco(),.
                          Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Nº Documento",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool conexao = await temConexao();

                                  if (conexao == true) {
                                    final result = Navigator.pushNamed(context,
                                        '/inventario_selecionar_lista');

                                    result.then((value) async {
                                      try {
                                        if (value != null) {
                                          inventario = value;
                                          lista_artigo_inventario =
                                              new List<ArtigoInventario>();
                                          lista_artigo_inventario =
                                              await _fetchLinhaInventario(
                                                  int.parse(inventario
                                                      .documentoNumero),
                                                  0,
                                                  0);

                                          if (lista_artigo_inventario == null) {
                                            SessaoApiProvider.refreshToken();
                                            lista_artigo_inventario =
                                                await _fetchLinhaInventario(
                                                    int.parse(inventario
                                                        .documentoNumero),
                                                    0,
                                                    0);
                                          }
                                          index = 0;

                                          actualizarEstado();
                                        }
                                      } catch (e) {
                                        print("Exception");
                                        print(e);
                                      }
                                    }).catchError((e) {
                                      print("exception catch");
                                      print(e);
                                    });
                                  } else {
                                    alerta_info(
                                        contexto, "Verifique sua conexão.");
                                  }
                                },
                                child: Text(
                                  inventarioNumDoc,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),

                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  // reverse: true,
                  shrinkWrap: true,
                  itemCount: items.length,

                  itemBuilder: (context, i) {
                    // index = i;
                    return items[i];
                    // ListTile(
                    //   title: Text('${items[index]}'),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.blue),
              label: 'Pesquisar',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.barcode, color: Colors.blue),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline, color: Colors.blue),
              label: 'terminar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: () async {
        if (artigos != null && artigos.length > 0) {
          bool rv = await createAlertDialog(context);
          print('alert ' + rv.toString());
          return rv;
        } else {
          return true;
        }
      },
    );
  }

  int _selectedIndex = 0;

  // Future<void> scanBarCode() {
  //   // dynamic codigoBarra = FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //   //     "#ff6666", "Cancelar", true, ScanMode.DEFAULT);

  //   String codigoBarra = '5449000045478';

  //   try {
  //     if (codigoBarra != null) {
  //       print(codigoBarra);
  //       int i = 0;
  //       lista_artigo_inventario.forEach((artigo) async {
  //         if (artigo.codigoBarra == codigoBarra) {
  //           // print("Encontrado");

  //           print("ARtigo " + artigo.artigo);
  //           // print("descricao " + artigo.descricao);
  //           // BuildContext contexto = posicao[i].currentContext;
  //           // posicao[i].currentState.setState(() {

  //           //             });
  //           // contexto.

  //           setState(() {
  //             // items = getListaArtigo(lista_artigo_inventario);
  //             posicao[i] = true;
  //           });
  //           _scrollController
  //               .animateTo(
  //             (94.0 * i),
  //             curve: Curves.easeInToLinear,
  //             duration: const Duration(milliseconds: 100),
  //           )
  //               .then((value) {
  //             print('scroll');
  //           });
  //         }
  //         i++;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> scanBarCode() async {
    String codigoBarra = null;
    try {
      // codigoBarra = FlutterBarcodeScanner.getBarcodeStreamReceiver(
      //     "#ff6666", "Cancelar", true, ScanMode.DEFAULT);
      codigoBarra = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.DEFAULT);
      print(codigoBarra);
    } catch (e) {
      print("Ocorreu um erro: ");
      print(e);
    }
    // String codigoBarra = '6935364092313';

    try {
      if (codigoBarra != null) {
        print(codigoBarra);
        int i = 0;
        lista_artigo_inventario.forEach((artigo) async {
          if (artigo.codigoBarra == codigoBarra) {
            print("ARtigo " + artigo.artigo);
            posicao[i] = true;
            _scrollController
                .animateTo(
              (94.0 * i),
              curve: Curves.easeInToLinear,
              duration: const Duration(milliseconds: 100),
            )
                .then((value) {
              print('scroll');
            });
          }
          i++;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _onItemTapped(int index) async {
    // Sair
    if (index == 0) {
      setState(() {
        evtPesquisar = true;
      });
    } else if (index == 1) {
      // Ler codigo de barra de um artigo e identificar se esta
      // na lista de ArtigoExpedição, se localizado, alterar as quantidades
      // a expedir e alterar o estado da linha como processado ou actualizado

      //
      await scanBarCode();
      // _scrollController.jumpTo(_scrollController.);
      actualizarEstado();

      // Terminar
    } else if (index == 2) {
      createAlertDialogEncomendaProcesso(BuildContext context) {
        bool rv = false;
        return showDialog(
            context: contexto,
            builder: (contexto) {
              // 1 minuto ate fechar a janela devido a demora do processo de envio de encomenda
              Future.delayed(Duration(seconds: 60), () {
                // alerta_info(contexto, "Parado processo devido o tempo de espera!");
                if (this.mounted) {
                  setState(() {
                    rv = true;
                  });
                }
                // Navigator.of(context).pop(true);
              });
              return WillPopScope(
                child: AlertDialog(
                  title: Center(child: Text('Aguarde')),
                  content: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                ),
                onWillPop: () async {
                  return rv;
                },
              );
            });
      }

      bool dado = false; //await temDados('Sem acesso a internet!', contexto);
      bool localizacao = false; //await temLocalizacao();
      bool conexao = await temConexao();
      if (conexao == true) {
        ArtigoInventario.postInventario(
                inventario, listaInventarioDisplayFiltro)
            .then((value) async {
          if (value.statusCode == 200) {
            await Navigator.pushReplacementNamed(
                contexto, '/inventario_sucesso');
          } else if (value.statusCode == 401 || value.statusCode == 500) {
            //  #TODO informar ao usuario sobre a renovação da sessão
            // mostrando mensagem e um widget de LOADING
            alerta_info(contexto, 'Aguarde a sua sessão esta a ser renovada');
            await SessaoApiProvider.refreshToken();
          } else {
            alerta_info(contexto,
                'Servidor não respondeu com sucesso o envio da inventario! Por favor tente novamente');
          }
        }).catchError((err) {
          print('[postInventario] ERRO');
          print(err);
          if (this.mounted == true) {
            setState(() {
              erroEncomenda = true;
            });
          }

          alerta_info(contexto,
              'Ocorreu um erro interno ao enviar expedição! Por favor tente novamente');
        });
      } else {
        alerta_info(contexto, "Verifique sua conexão.");
      }
    }
    _selectedIndex = index;
  }

  void actualizarEstado() {
    /**
           * Se tiver artigos selecionados.
          *   limpar a lista artigos previamente selecionados
          **/

    encomendaItens.clear();
    items.clear();

    setState(() {
      inventarioNumDoc = inventario.documentoNumero.toString();
      items = getListaArtigo(listaInventarioDisplayFiltro);
    });
  }

  Card encomendaItemVazio() {
    return Card(
        child: Column(
      children: <Widget>[
        const SizedBox(height: 50),
        RaisedButton(
          color: Colors.blue,
          onPressed: () async {
            // Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
            await Navigator.pushNamed(contexto, '/artigo_selecionar_lista');
          },
          child: const Text('Adicionar ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 50),
      ],
    ));
  }

  void removeEncomenda(Artigo a) {
    for (var i = 0; i < encomendaItens.length; i++) {
      if (encomendaItens[i].child.artigo.artigo == a.artigo) {
        encomendaItens.removeAt(i);
        artigos.removeAt(i);
      }
    }
  }

  Future<bool> temLocalizacao() async {
    bool rv = false;

    //

    return rv;
  }

  createAlertDialogAssinatura(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Atenção')),
            content: Container(
                height: 40,
                alignment: Alignment.center,
                child: Center(
                    child: Text(
                        'Encomenda não certificada.\n Por favor Assine antes de gravar'))),
            actions: [
              new IconButton(
                color: Colors.blue,
                icon: new Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  Padding espaco() {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
    );
  }

  // Retornar lista de artigos por expedir convertidos em widgets
  List<Widget> getListaArtigo(List<ArtigoInventario> artigos) {
    List<Widget> lista_widget = List<Widget>();
    lista_widget.clear();
    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        lista_widget.add(artigoInventario(artigo));
      });
    } else {
      lista_widget.add(Text(
        "Sem Artigo",
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ));
    }

    return lista_widget;
  }

  // Widget representado cada Artigo de uma expedição
  Widget artigoInventario(ArtigoInventario artigo) {
    Slidable slide = Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: inventarioItem(artigo),
      // secondaryActions: <Widget>[
      //   IconSlideAction(
      //     caption: 'Remover',
      //     color: Colors.red,
      //     icon: Icons.delete,
      //     onTap: () {
      //       // setState(() {
      //       //   removeEncomenda(artigo);
      //       //   // actualizarEstado();
      //       // });
      //     },
      //   ),
      // ],
    );
    // slide.
    return slide;
  }

  // buscar as linhas de uma determinada Expedição identificado pelo 'Numero de documento'
  Future<List<ArtigoInventario>> _fetchLinhaInventario(
      int numDoc, int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return <ArtigoInventario>[];
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = SessaoApiProvider.getProtocolo();

        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/InventarioStockController/Inventario/lista/' +
                numDoc.toString(),
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          dynamic data = json.decode(response.body);
          ArtigoInventario _artigoInv = new ArtigoInventario();
          lista_artigo_inventario.clear();
          listaInventarioDisplayFiltro.clear();
          inventarioListaArmazemDisplay.clear();
          await data.map((inventario) {
            _artigoInv = ArtigoInventario.fromJson(json.decode(inventario));
            agruparArtigoArmazem(_artigoInv);
            bool rv = existeArtigoNaLista(
                listaInventarioDisplayFiltro, _artigoInv.artigo);
            if (rv == false) listaInventarioDisplayFiltro.add(_artigoInv);

            lista_artigo_inventario.add(_artigoInv);
          }).toList();
          posicao = List<bool>.filled(lista_artigo_inventario.length, false);

          return lista_artigo_inventario;
        } else if (response.statusCode == 401) {
          await SessaoApiProvider.refreshToken();
          return _fetchLinhaInventario(numDoc, 0, 0);
        }
        final msg = json.decode(response.body);
        print("Ocorreu um erro" + msg.toString());
      }
    } catch (e) {
      throw e;
    }

    return null;
  }

  ArtigoInventarioCard inventarioItem(ArtigoInventario artigo) {
    var artigoQuantidade;
    TextEditingController txtArtigoQtd = new TextEditingController();
    txtArtigoQtd.text = artigo.quantidadeStock.toString();
    Color ArtigoEstadoCor = Colors.blue;
    if (artigo.quantidadeStockReserva > 0) {
      ArtigoEstadoCor = Colors.red[200];
    } else {
      ArtigoEstadoCor = Colors.white;
    }
    // posicao[index] = false;
    bool state = false;
    if (posicao[idx] == true) {
      txtArtigoQtd.selection = TextSelection(
          baseOffset: 0, extentOffset: txtArtigoQtd.value.text.length);
      state = true;
    }
    final GlobalKey expansionTileKey = GlobalKey();
    // posicao[idx++] = expansionTileKey;
    idx++;
    return ArtigoInventarioCard(
      color: ArtigoEstadoCor,
      artigo: artigo,
      child: Column(
        children: <Widget>[
          ExpansionTile(
            initiallyExpanded: state,
            key: expansionTileKey,
            title: Text(artigo.descricao,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.blue,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12)),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Artigo: " + artigo.artigo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                    if (artigo.quantidadeStockReserva <= 0)
                      IconButton(
                        color: Colors.blue,
                        icon: const Icon(Icons.create),
                        tooltip: 'Artigo Quantidade',
                        onPressed: () async {
                          String msgQtd = "";
                          await showDialog(
                            context: contexto,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                content: StatefulBuilder(
                                    // You need this, notice the parameters below:
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                  return Column(
                                    // Then, the content of your dialog.
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                          child: Text(artigo.descricao,
                                              style: TextStyle(fontSize: 12))),
                                      Center(
                                          child: Text(
                                              'Quantidade em ' + artigo.unidade,
                                              style: TextStyle(fontSize: 12))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columnSpacing: 10.0,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  'Armaz.',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 11),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Loc.',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 11),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Lote',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 11),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Quantidade.',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ],
                                            rows: buildInventarioDataRow(
                                              artigo,
                                            ),
                                          )),
                                      Container(
                                          alignment: Alignment.bottomRight,
                                          child: MaterialButton(
                                            elevation: 5.0,
                                            child: Text('Fechar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ))
                                    ],
                                  );
                                }),
                                actions: null,
                              );
                            },
                          );
                        },
                      )
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     OutlinedButton(
                //       onPressed: () {
                //         print('Received click');
                //       },
                //       child: const Text('Quantidade'),
                //     ),
                //   ],
                // ),
                //     Row(
                //       children: <Widget>[
                //         Text("Lote: " + artigo.lote,
                //             overflow: TextOverflow.ellipsis,
                //             style: TextStyle(color: Colors.blue, fontSize: 13)),
                //       ],
                //     ),
                //   ],
                // ),
                // children: [
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       Padding(
                //         padding:
                //             EdgeInsets.only(top: 15, left: 15, right: 5, bottom: 0),
                //         child: Text(
                //           "Localização: ",
                //           style: TextStyle(
                //             color: Colors.blue,
                //             fontSize: 13,
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding:
                //             EdgeInsets.only(top: 15, left: 15, right: 5, bottom: 0),
                //         child: Text(
                //           artigo.localizacao,
                //           style: TextStyle(
                //             color: Colors.blue,
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       Padding(
                //         padding:
                //             EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 0),
                //         child: Text(
                //           "Quantidade: ",
                //           style: TextStyle(
                //             color: Colors.blue,
                //             fontSize: 13,
                //           ),
                //         ),
                //       ),
                //       // Spacer(),
                //       Container(
                //         padding:
                //             EdgeInsets.only(top: 0, left: 15, right: 5, bottom: 0),
                //         child: TextField(
                //           autofocus: true,
                //           keyboardType: TextInputType.number,
                //           controller: txtArtigoQtd,
                //           onChanged: (value) {
                //             try {
                //               if (double.parse(txtArtigoQtd.text) > 0) {
                //                 artigo.quantidadeStock =
                //                     double.parse(txtArtigoQtd.text);
                //               }
                //             } catch (e) {
                //               print(e);
                //             }
                //           },
                //           onTap: () {
                //             txtArtigoQtd.selection = TextSelection(
                //                 baseOffset: 0,
                //                 extentOffset: txtArtigoQtd.value.text.length);
                //           },
                //           textAlign: TextAlign.start,
                //           style: TextStyle(
                //             color: Colors.blue,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 13,
                //           ),
                //         ),
                //         width: 100,
                //       ),
                //     ],
                //   ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 0),
            //       child: Text(artigo.descricao,
            //           overflow: TextOverflow.ellipsis,
            //           style: TextStyle(
            //               color: Colors.blue,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16)),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Padding(
            //       padding:
            //           EdgeInsets.only(top: 15, left: 15, right: 5, bottom: 0),
            //       child: Text("Artigo: ",
            //           style: TextStyle(color: Colors.blue, fontSize: 16)),
            //     ),
            //     Padding(
            //       padding:
            //           EdgeInsets.only(top: 15, left: 15, right: 5, bottom: 0),
            //       child: Text(artigo.artigo,
            //           style: TextStyle(
            //               color: Colors.blue,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16)),
            //     ),
            //   ],
          ),
        ],
      ),
    );
  }

  Widget togglePesquisa() {
    return evtPesquisar
        ? new TextField(
            key: inventarioPesquisaKey,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Pesquise aqui...',
            ),
            onChanged: (value) {
              // items.clear();

              setState(() {
                if (value.length >= 0) {
                  items =
                      PesquisaListaArtigo(listaInventarioDisplayFiltro, value);
                } else {
                  items = getListaArtigo(listaInventarioDisplayFiltro);
                }
              });
            },
            onEditingComplete: () {
              if (inventarioPesquisarController.text.length == 0) {
                setState(() {
                  evtPesquisar = false;
                });
              }
            },
            onSubmitted: (value) {
              if (value.length == 0) {
                setState(() {
                  evtPesquisar = false;
                });
              }
            },
            controller: inventarioPesquisarController,
          )
        : new Text('Inventario');
  }

  List<Widget> PesquisaListaArtigo(
      List<ArtigoInventario> artigos, String keyword) {
    List<Widget> lista_widget = List<Widget>();
    if (keyword == null || keyword.length == 0) {
      return getListaArtigo(artigos);
    }
    keyword = keyword.toLowerCase();
    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        if (artigo.artigo.toLowerCase().contains(keyword) ||
            artigo.descricao.toLowerCase().contains(keyword)) {
          lista_widget.add(artigoInventario(artigo));
        }
      });
    }

    if (lista_widget.length == 0) {
      lista_widget.add(Container(
          height: 60,
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Center(
            child: Text(
              "Artigo não encontrado.",
              style: TextStyle(color: Colors.blue, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )));
    }

    return lista_widget;
  }

  void agruparArtigoArmazem(ArtigoInventario _artigo) {
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
        _artigo.quantidadeStock.toString();

    if (inventarioListaArmazemDisplay.containsKey(_artigo.artigo)) {
      if (!inventarioListaArmazemDisplay[_artigo.artigo].contains(rv))
        inventarioListaArmazemDisplay[_artigo.artigo].add(rv);
    } else {
      inventarioListaArmazemDisplay[_artigo.artigo] = new List<String>();
      inventarioListaArmazemDisplay[_artigo.artigo].add(rv);
    }
  }

  List<DataRow> buildInventarioDataRow(ArtigoInventario artigoObj) {
    List<DataRow> listaDataRow = List<DataRow>();
    String artigo = artigoObj.artigo;

    Artigo _artigo = Artigo.getArtigo(artigoListaDisplayFiltro, artigo);

    for (int i = 0; i < _artigo.artigoArmazem.length; i++) {
      ArtigoArmazem armazem = _artigo.artigoArmazem[i];
      //igonorar lote <L01> se o artigo ja tiver controlo de lote.
      if ((_artigo.artigoArmazem.length > 1 && armazem.lote == "<L01>") ||
          armazem.armazem != artigoObj.armazem) continue;

      listaDataRow.add(DataRow(
        cells: <DataCell>[
          DataCell(
            Text(armazem.armazem, style: TextStyle(fontSize: 11)),
          ),
          DataCell(Text(armazem.localizacao, style: TextStyle(fontSize: 11))),
          DataCell(Text(armazem.lote, style: TextStyle(fontSize: 11))),
          DataCell(TextFieldCustom(artigoObj, i)),
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
    for (int i = 0; i < inventarioListaArmazemDisplay[artigo].length; i++) {
      String armazem = inventarioListaArmazemDisplay[artigo][i];
      List<String> arm = armazem.split("-");
      String _armazem = arm[0] == "@" ? "" : arm[0];
      String _loc = arm[1] == "@" ? "" : arm[1];
      String _lote = arm[2] == "@" ? "" : arm[2];

      for (int j = 0; j < lista_artigo_inventario.length; j++) {
        ArtigoInventario _artInv = new ArtigoInventario();
        _artInv = lista_artigo_inventario[j];
        if (_artInv.artigo == artigo &&
            _artInv.armazem == _armazem &&
            _artInv.localizacao == _loc &&
            _artInv.lote == _lote &&
            artigoKey.contains(armazem)) {
          lista_artigo_inventario[j].quantidadeStock = quantidade;
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
}

class ArtigoInventarioCard extends Card {
  ArtigoInventarioCard(
      {Key key,
      this.color,
      this.elevation,
      this.shape,
      this.borderOnForeground = true,
      this.margin,
      this.clipBehavior,
      this.child,
      this.semanticContainer = true,
      this.artigo})
      : super(
          key: key,
          color: color,
          elevation: elevation,
          shape: shape,
          borderOnForeground: borderOnForeground,
          margin: margin,
          clipBehavior: clipBehavior,
        );
  final Color color;
  final double elevation;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final bool borderOnForeground;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final bool semanticContainer;
  final ArtigoInventario artigo;
}
