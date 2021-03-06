import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/artigo/util.dart';
import 'package:primobile/expedicao/models/expedicao.dart';
import 'package:primobile/expedicao/models/models.dart';
import 'package:primobile/expedicao/util.dart';
import 'package:primobile/inventario/inventario.dart';
import 'package:primobile/inventario/models/artigo_inventario.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/util/util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

BuildContext contexto;
http.Client httpClient = http.Client();
List<ArtigoExpedicao> linhaExpedicao = List<ArtigoExpedicao>();
ScrollController _scrollController = new ScrollController();
TextEditingController txtPesquisar = new TextEditingController();
List<bool> posicao;
int idx = 0;

class ExpedicaoEditorPage extends StatefulWidget {
  ExpedicaoEditorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExpedicaoEditorPageState createState() => new _ExpedicaoEditorPageState();
}

class _ExpedicaoEditorPageState extends State<ExpedicaoEditorPage> {
  TextEditingController txtArtigoQtd = new TextEditingController();
  bool evtPesquisar = false;
  final GlobalKey expedicaoPesquisaKey = GlobalKey();

  BuildContext context;
  var items = List<dynamic>();
  final List<dynamic> encomendaItens = <dynamic>[
    // encomendaItemVazio(),
  ];

  double mercadServicValor = 0.0;
  double noIva = 0.0;
  double ivaTotal = 0.0;
  double subtotal = 0.0;
  double totalVenda = 0.0;
  Expedicao expedicao = Expedicao();
  double iva = 17.0;
  List<Artigo> artigos = new List<Artigo>();
  List artigoJson = List();
  bool erroEncomenda = false;
  String expedicaoNumDoc = "Selecionar";
  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    // items.addAll(encomendaItens);

    super.initState();
    expedicaoPesquisarController.text = "";
    lista_artigo_expedicao.clear();

    try {
      updateConnection(() {
        if (this.mounted)
          setState(() {
            PRIMARY_COLOR = CONEXAO_ON_COLOR;
          });
      }, () {
        if (this.mounted)
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

  // Future<bool> createAlertDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Center(child: Text('Atenção')),
  //           content: Text('Deseja Cancelar Expedição ?'),
  //           actions: <Widget>[
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('Sim'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(true);
  //               },
  //             ),
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('Não'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(false);
  //               },
  //             ),
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('Salvar'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(false);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
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
              if (lista_artigo_expedicao != null &&
                  lista_artigo_expedicao.length > 0) {
                createAlertDialog(context, "Deseja Cancelar Expedição ?", null)
                    .then((sair) {
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
                height: 170,
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
                      height: 100,
                      padding: EdgeInsets.only(
                          top: 0, left: 16, right: 16, bottom: 0),
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
                                "Nº Documento:",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.blue),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool conexao = await temConexao();

                                  if (conexao == true) {
                                    final result = Navigator.pushNamed(
                                        context, '/expedicao_selecionar_lista');

                                    result.then((value) async {
                                      expedicao = value;
                                      await _fetchLinhaExpedicao(
                                          expedicao.expedicao, 0, 0);

                                      if (lista_artigo_expedicao == null) {
                                        SessaoApiProvider.refreshToken();
                                        await _fetchLinhaExpedicao(
                                            int.parse(
                                                expedicao.expedicao.toString()),
                                            0,
                                            0);
                                      }
                                      posicao = List.filled(
                                          lista_artigo_expedicao.length, false);

                                      actualizarEstado();
                                    });
                                  } else {
                                    alerta_info(
                                        contexto, "Verifique sua conexão.");
                                  }
                                },
                                child: Text(
                                  expedicaoNumDoc,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          // Spacer(),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: <Widget>[
                          //     Text(
                          //       "",
                          //       style:
                          //           TextStyle(fontSize: 15, color: Colors.blue),
                          //     ),
                          //     Text(
                          //       "",
                          //       style: TextStyle(
                          //           fontSize: 15,
                          //           color: Colors.blue,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ],
                          // ),
                          Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Text(
                              //   "Armazem",
                              //   style:
                              //       TextStyle(fontSize: 18, color: Colors.blue),
                              // ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
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
          bool rv = await createAlertDialog(
              context, "Deseja Cancelar Expedição ?", null);
          print('alert ' + rv.toString());
          return rv;
        } else {
          return true;
        }
      },
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    // Sair
    if (index == 0) {
      // if (artigos != null && artigos.length > 0) {
      //   createAlertDialog(contexto).then((sair) {
      //     if (sair == true) {
      //       Navigator.of(contexto).pop();
      //     }
      //   });
      // }

      setState(() {
        evtPesquisar = true;
      });
    } else if (index == 1) {
      // Ler codigo de barra de um artigo e identificar se esta
      // na lista de ArtigoExpedição, se localizado, alterar as quantidades
      // a expedir e alterar o estado da linha como processado ou actualizado

      // FlutterBarcodeScanner.getBarcodeStreamReceiver(
      //         "#ff6666", "Cancelar", true, ScanMode.DEFAULT)
      //     .listen((codigoBarra) {
      //   if (codigoBarra != null && codigoBarra != "-1") {
      //     print(codigoBarra);
      //     lista_artigo_expedicao.forEach((artigo) {
      //       if (artigo.codigoBarra == codigoBarra) {
      //         print("Encontrado");
      //       }
      //     });
      //   }
      // });
      await scanBarCode();

      actualizarEstado();

      // Terminar
    } else if (index == 2) {
      if (lista_artigo_expedicao != null &&
          listaArtigoExpedicaoDisplayFiltro.length > 0) {
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

        bool conexao = await temConexao();

        if (conexao == true) {
          ArtigoExpedicao.postExpedicao(
                  expedicao, listaArtigoExpedicaoDisplayFiltro)
              .then((value) async {
            if (value.statusCode == 200) {
              await Navigator.pushReplacementNamed(
                  contexto, '/expedicao_sucesso');
            } else if (value.statusCode == 401 || value.statusCode == 500) {
              //  #TODO informar ao usuario sobre a renovação da sessão
              // mostrando mensagem e um widget de LOADING
              alerta_info(contexto, 'Aguarde a sua sessão esta a ser renovada');
              await SessaoApiProvider.refreshToken();
            } else {
              alerta_info(contexto,
                  'Servidor não respondeu com sucesso o envio da expedição! Por favor tente novamente');
            }
          }).catchError((err) {
            print('[postExpedicao] ERRO');
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
    } else {
      if (this.mounted == true) {
        setState(() {
          erroEncomenda = true;
        });
      }
    }
  }

  void actualizarEstado() {
    /**
           * Se tiver artigos selecionados.
          *   limpar a lista artigos previamente selecionados
          **/

    // items.clear();

    setState(() {
      items.clear();
      encomendaItens.clear();
      expedicaoNumDoc = expedicao.expedicao.toString();

      items = getListaArtigo(listaArtigoExpedicaoDisplayFiltro);
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
  List<Widget> getListaArtigo(List<ArtigoExpedicao> artigos) {
    List<Widget> lista_widget = List<Widget>();

    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        lista_widget.add(expedicaoItem(artigo));
      });
    } else {
      lista_widget.add(Text(
        "Sem Artigo",
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ));
    }

    return lista_widget;
  }

  List<Widget> PesquisaListaArtigo(
      List<ArtigoExpedicao> artigos, String keyword) {
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
          lista_widget.add(expedicaoItem(artigo));
        }
      });
    }

    if (lista_widget.length == 0) {
      lista_widget.add(Container(
          height: 100,
          padding: EdgeInsets.all(20),
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

  Widget buildArtigoExpedicao(List<ArtigoExpedicao> artigos, int index) {
    List<Widget> lista_widget = List<Widget>();
    if (artigos != null || artigos.length > 0) {
      return (expedicaoItem(artigos[index]));
    }

    return Text("Sem Artigo",
        style: TextStyle(color: Colors.blue, fontSize: 14));
  }

  // Widget representado cada Artigo de uma expedição
  // Widget artigoExpedicao(ArtigoExpedicao artigo) {
  //   // return Slidable(
  //   //   actionPane: SlidableDrawerActionPane(),
  //   //   actionExtentRatio: 0.25,
  //   //   child:,
  //   //   // secondaryActions: <Widget>[
  //   //   //   IconSlideAction(
  //   //   //     caption: 'Remover',
  //   //   //     color: Colors.red,
  //   //   //     icon: Icons.delete,
  //   //   //     onTap: () {
  //   //   //       // setState(() {
  //   //   //       //   removeEncomenda(artigo);
  //   //   //       //   // actualizarEstado();
  //   //   //       // });
  //   //   //     },
  //   //   //   ),
  //   //   // ],
  //   // );
  //   //
  // return expedicaoItem(artigo);
  // }

  // buscar as linhas de uma determinada Expedição identificado pelo 'Numero de documento'
  Future<List<ArtigoExpedicao>> _fetchLinhaExpedicao(
      int numDoc, int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;
      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return <ArtigoExpedicao>[];
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();

        final response = await httpClient.get(
            protocolo +
                baseUrl +
                '/WebApi/ExpedicaoController/Expedicao/lista/' +
                numDoc.toString(),
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            });

        if (response.statusCode == 200) {
          dynamic data = json.decode(response.body);
          ArtigoExpedicao _artigoExp = new ArtigoExpedicao();

          listaArtigoExpedicaoDisplayFiltro.clear();
          listaArtigoExpedicaoDisplay.clear();
          expedicaoListaArmazemDisplay.clear();
          lista_artigo_expedicao.clear();
          await data.map((expedicao) async {
            _artigoExp = ArtigoExpedicao.fromJson(json.decode(expedicao));
            Map<String, dynamic> map = json.decode(expedicao);
            agruparArtigoArmazem(_artigoExp);

            if (artigoListaDisplayFiltro == null ||
                artigoListaDisplayFiltro.length == 0) {
              List data = json.decode(await getCacheData("artigo"));
              artigoListaDisplayFiltro = new List<Artigo>();
              if (data == null || data.length == 0) return null;
              for (dynamic rawArtigo in data) {
                artigoListaDisplayFiltro.add(Artigo.fromJson(rawArtigo));
              }
            }
            _artigoExp.setArtigo(artigoListaDisplayFiltro);
            _artigoExp.artigoObj.artigoArmazem.forEach((obj) {
              if (obj.armazem == map['armazem'] &&
                  obj.lote == map['lote'] &&
                  obj.localizacao == map['localizacao']) {
                obj.quantidadeExpedir =
                    map['quantidadeExpedir'] ?? map['quantidade_expedir'];
                obj.quantidadePendente =
                    map['quantidadePendente'] ?? map['quantidade_pendente'];
              }
            });

            bool rv = existeArtigoNaLista(
                listaArtigoExpedicaoDisplayFiltro, _artigoExp.artigo);
            if (rv == false) listaArtigoExpedicaoDisplayFiltro.add(_artigoExp);

            lista_artigo_expedicao.add(_artigoExp);
          }).toList();

          return listaArtigoExpedicaoDisplayFiltro;
        } else if (response.statusCode == 401) {
          await SessaoApiProvider.refreshToken();
          return _fetchLinhaExpedicao(numDoc, 0, 0);
        }
        final msg = json.decode(response.body);
        print("Ocorreu um erro" + msg["Message"]);
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  ArtigoExpedicaoCard expedicaoItem(ArtigoExpedicao artigo) {
    String qtdExpedir = artigo.quantidadeExpedir.toString();
    ArtigoExpedicaoCard artigoInventario;
    final GlobalKey expansionTileKey = GlobalKey();

    if (posicao.length > 0 && posicao[idx] == true) {
      // txtArtigoQtd.selection = TextSelection(
      //     baseOffset: 0, extentOffset: txtArtigoQtd.value.text.length);
      artigoInventario =
          buildExpedicaoItem(artigo, true, expansionTileKey, qtdExpedir);
    } else {
      artigoInventario =
          buildExpedicaoItem(artigo, false, expansionTileKey, qtdExpedir);
    }
    idx++;

    return artigoInventario;
  }

  ArtigoExpedicaoCard buildExpedicaoItem(
      ArtigoExpedicao artigo, bool state, GlobalKey key, String qtdExpedir) {
    TextEditingController txtPesquisa = TextEditingController();
    txtPesquisa.text = qtdExpedir;

    return ArtigoExpedicaoCard(
      artigo: artigo,
      child: Column(
        children: <Widget>[
          ExpansionTile(
            key: key,
            maintainState: state,
            initiallyExpanded: state,
            title: Text(artigo.descricao,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blue, fontSize: 13)),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Artigo:    " + artigo.artigo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blue, fontSize: 13)),
                  ],
                ),
              ],
            ),
            children: [
              Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 5),
                    child: Text(
                      "Qtd. Pendente: ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 0, right: 20, bottom: 5),
                    child: Text(
                      artigo.totalPendente().toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 15, right: 5, bottom: 0),
                    child: Text(
                      "Qtd. Expedir: ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    color: Colors.blue,
                    icon: const Icon(Icons.create),
                    tooltip: 'Artigo Quantidade',
                    onPressed: () async {
                      String msgQtd = "";
                      await showDialog(
                        context: contexto,
                        builder: (BuildContext context) {
                          ScrollController scrollControl =
                              new ScrollController();
                          return AlertDialog(
                            scrollable: true,
                            content: StatefulBuilder(
                                // You need this, notice the parameters below:
                                builder: (BuildContext context,
                                    StateSetter setState) {
                              return Column(
                                // Then, the content of your dialog.
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                      child: Text(artigo.descricao,
                                          style: TextStyle(fontSize: 12))),
                                  Center(
                                      child: Text(
                                          'Quantidade em ' +
                                                  artigo.artigoObj.unidade ??
                                              "",
                                          style: TextStyle(fontSize: 12))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  new ConstrainedBox(
                                      constraints: new BoxConstraints(
                                        maxHeight: 250.0,
                                      ),
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: new Scrollbar(
                                              controller: scrollControl,
                                              isAlwaysShown: true,
                                              child: SingleChildScrollView(
                                                  controller: scrollControl,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: DataTable(
                                                    columnSpacing: 9.0,
                                                    columns: const <DataColumn>[
                                                      DataColumn(
                                                        label: Text(
                                                          'Armaz.',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Loc.',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Lote',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Qtd. Pendente',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Quantidade.',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                    ],
                                                    rows:
                                                        buildInventarioDataRow(
                                                            artigo),
                                                  ))))),
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
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       top: 5, left: 15, right: 20, bottom: 15),
                  //   child: Container(
                  //     child: TextField(
                  //       autofocus: true,
                  //       keyboardType: TextInputType.number,
                  //       controller: txtPesquisa,
                  //       onChanged: (value) {
                  //         try {
                  //           if (double.parse(txtPesquisa.text) > 0) {
                  //             artigo.quantidadeExpedir =
                  //                 double.parse(txtPesquisa.text);
                  //           }
                  //         } catch (e) {}
                  //       },
                  //       onTap: () {
                  //         txtPesquisa.selection = TextSelection(
                  //             baseOffset: 0,
                  //             extentOffset: txtPesquisa.value.text.length);
                  //       },
                  //       textAlign: TextAlign.end,
                  //       style: TextStyle(
                  //         color: Colors.blue,
                  //         fontSize: 13,
                  //       ),
                  //     ),
                  //     width: 100,
                  //   ),
                  // ),
                ],
              )
            ],
          ),

          // Padding(
          //   padding: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 4),
          // ),
        ],
      ),
    );
  }

//   void scanBarCode() {
//     // dynamic codigoBarra = FlutterBarcodeScanner.getBarcodeStreamReceiver(
//     //     "#ff6666", "Cancelar", true, ScanMode.DEFAULT);

//     String codigoBarra = '6935364092313';

//     try {
//       if (codigoBarra != null) {
//         print(codigoBarra);
//         int i = 0;
//         lista_artigo_expedicao.forEach((artigo) async {
//           if (artigo.codigoBarra == codigoBarra) {
//             // print("Encontrado");

//             print("ARtigo " + artigo.artigo);
//             // print("descricao " + artigo.descricao);

//             _scrollController
//                 .animateTo(
//               (94.0 * i),
//               curve: Curves.easeInToLinear,
//               duration: const Duration(milliseconds: 300),
//             )
//                 .then((value) {
//               print('scroll');
//             });
//           }
//           i++;
//         });

//         posicao[i] = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
//
//
//
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
        lista_artigo_expedicao.forEach((artigo) async {
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

  Widget togglePesquisa() {
    return evtPesquisar
        ? new TextField(
            key: expedicaoPesquisaKey,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Pesquise aqui...',
            ),
            onChanged: (value) {
              // items.clear();

              setState(() {
                if (value.length >= 0) {
                  items = PesquisaListaArtigo(
                      listaArtigoExpedicaoDisplayFiltro, value);
                } else {
                  items = getListaArtigo(listaArtigoExpedicaoDisplayFiltro);
                }
              });
            },
            onEditingComplete: () {
              if (expedicaoPesquisarController.text.length == 0) {
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
            controller: expedicaoPesquisarController,
          )
        : new Text('Expedição');
  }
}

class ArtigoExpedicaoCard extends Card {
  ArtigoExpedicaoCard(
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
  final ArtigoExpedicao artigo;
}
