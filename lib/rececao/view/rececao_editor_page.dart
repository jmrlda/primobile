import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primobile/artigo/models/models.dart';
import 'package:primobile/rececao/models/models.dart';
import 'package:primobile/rececao/util.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:primobile/util/util.dart';

BuildContext contexto;
http.Client httpClient = http.Client();
List<ArtigoRececao> linhaRececao = List<ArtigoRececao>();
ScrollController _scrollController = new ScrollController();
int idx = 0;

class RececaoEditorPage extends StatefulWidget {
  RececaoEditorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RececaoEditorPageState createState() => new _RececaoEditorPageState();
}

class _RececaoEditorPageState extends State<RececaoEditorPage> {
  TextEditingController txtClienteController = TextEditingController();
  TextEditingController txtQtdArtigoController = TextEditingController();

  TextEditingController txtArtigoQtdRecebida = new TextEditingController();
  TextEditingController txtArtigoQtdRejeitada = new TextEditingController();

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
  Rececao rececao = Rececao();
  double iva = 17.0;
  List<Artigo> artigos = new List<Artigo>();
  List artigoJson = List();
  bool erroEncomenda = false;
  String rececaoNumDoc = "Selecionar";
  List<bool> posicao;
  bool evtPesquisar = false;
  final GlobalKey rececaoPesquisaKey = GlobalKey();

  @override
  void initState() {
    // encomendaItens.add(encomendaItemVazio());
    // items.addAll(encomendaItens);

    super.initState();

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
  //           content: Text('Deseja Cancelar Receção ?'),
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
              if (lista_artigo_rececao != null &&
                  lista_artigo_rececao.length > 0) {
                createAlertDialog(context, "Deseja Cancelar Receção ?", null)
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
                                        context, '/rececao_selecionar_lista');

                                    result.then((value) async {
                                      rececao = value;
                                      if (lista_artigo_rececao != null)
                                        lista_artigo_rececao.clear();
                                      await _fetchLinhaRececao(
                                          rececao.rececao, 0, 0);

                                      if (lista_artigo_rececao == null) {
                                        SessaoApiProvider.refreshToken();
                                        await _fetchLinhaRececao(
                                            int.parse(
                                                rececao.rececao.toString()),
                                            0,
                                            0);
                                      }

                                      posicao = List<bool>.filled(
                                          lista_artigo_rececao.length, false);

                                      actualizarEstado();
                                    }).catchError((e) {
                                      print('lista rececao erro');
                                      print(e);
                                    });
                                  } else {
                                    alerta_info(
                                        contexto, "Verifique sua conexão.");
                                  }
                                },
                                child: Text(
                                  rececaoNumDoc,
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
                          //       "Armazem",
                          //       style:
                          //           TextStyle(fontSize: 18, color: Colors.blue),
                          //     ),
                          //     Text(
                          //       "A1",
                          //       style: TextStyle(
                          //           fontSize: 18,
                          //           color: Colors.blue,
                          //           fontWeight: FontWeight.bold),
                          //     )
                          //   ],
                          // ),
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
              context, "Deseja Cancelar Receção ?", null);
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
      setState(() {
        evtPesquisar = true;
      });
    } else if (index == 1) {
      await scanBarCode();
      actualizarEstado();

      // Terminar
    } else if (index == 2) {
      // await Navigator.pushReplacementNamed(contexto, '/encomenda_sucesso');

      // createAlertDialogErroEncomenda
      if (lista_artigo_rececao != null && lista_artigo_rececao.length > 0) {
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
          ArtigoRececao.postRececao(rececao, listaArtigoRececaoDisplayFiltro)
              .then((value) async {
            if (value.statusCode == 200) {
              await Navigator.pushReplacementNamed(
                  contexto, '/rececao_sucesso');
            } else if (value.statusCode == 401 || value.statusCode == 500) {
              //  #TODO informar ao usuario sobre a renovação da sessão
              // mostrando mensagem e um widget de LOADING
              alerta_info(contexto, 'Aguarde a sua sessão esta a ser renovada');
              await SessaoApiProvider.refreshToken();
            } else {
              alerta_info(contexto,
                  'Servidor não respondeu com sucesso o envio da Receção! Por favor tente novamente');
            }
          }).catchError((err) {
            print('[postRececao] ERRO');
            print(err);
            if (this.mounted == true) {
              setState(() {
                erroEncomenda = true;
              });
            }

            alerta_info(contexto,
                'Ocorreu um erro interno ao enviar Receção! Por favor tente novamente');
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

    setState(() {
      encomendaItens.clear();
      items.clear();

      rececaoNumDoc = rececao.rececao.toString();
      items = getListaArtigo(listaArtigoRececaoDisplayFiltro);
    });
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

  Padding espaco() {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 4),
    );
  }

  // Retornar lista de artigos por expedir convertidos em widgets
  List<Widget> getListaArtigo(List<ArtigoRececao> artigos) {
    List<Widget> lista_widget = List<Widget>();

    if (artigos != null || artigos.length > 0) {
      int i = 0;
      artigos.forEach((artigo) {
        setState(() {
          lista_widget.add(artigoRececao(artigo));
        });
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
      List<ArtigoRececao> artigos, String keyword) {
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
          lista_widget.add(artigoRececao(artigo));
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

  // Widget representado cada Artigo de uma expedição
  Widget artigoRececao(ArtigoRececao artigo) {
    return rececaoItem(artigo);
  }

  // buscar as linhas de uma determinada Receção identificado pelo 'Numero de documento'
  Future<List<ArtigoRececao>> _fetchLinhaRececao(
      int numDoc, int startIndex, int limit) async {
    try {
      var sessao = await SessaoApiProvider.readSession();
      var response;

      if (sessao == null || sessao.length == 0) {
        print('Ficheiro sessao nao existe');
        return <ArtigoRececao>[];
      } else {
        String token = sessao['access_token'];
        String ip = sessao['ip_local'];
        String porta = sessao['porta'];
        String baseUrl = await SessaoApiProvider.getHostUrl();
        String protocolo = await SessaoApiProvider.getProtocolo();
        String rota = protocolo +
            baseUrl +
            '/WebApi/RececaoController/Rececao/lista/' +
            numDoc.toString();

        final response = await httpClient.get(rota, headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        });

        if (response.statusCode == 200) {
          List data = json.decode(response.body);
          ArtigoRececao _artigoRec = new ArtigoRececao();
          lista_artigo_rececao.clear();
          rececaoListaArmazemDisplay.clear();
          listaArtigoRececaoDisplayFiltro.clear();
          data.map((rececao) async {
            _artigoRec = ArtigoRececao.fromJson(json.decode(rececao));
            Map<String, dynamic> map = json.decode(rececao);

            agruparArtigoArmazem(_artigoRec);

            if (artigoListaDisplayFiltro == null ||
                artigoListaDisplayFiltro.length == 0) {
              String artigoJson = await getCacheData("artigo");
              List data;
              if (artigoJson != null) data = json.decode(artigoJson);
              if (data == null) return new List<Artigo>();

              artigoListaDisplayFiltro = new List<Artigo>();

              for (dynamic rawArtigo in data) {
                artigoListaDisplayFiltro.add(Artigo.fromJson(rawArtigo));
              }
            }
            _artigoRec.setArtigo(artigoListaDisplayFiltro);
            _artigoRec.artigoObj.artigoArmazem.forEach((obj) {
              if (obj.armazem == map['armazem'] &&
                  obj.lote == map['lote'] &&
                  obj.localizacao == map['localizacao']) {
                obj.quantidadeRecebido = double.tryParse(
                    map['quantidadeRecebido'].toString() ??
                        map['quantidade_recebido'].toString());
                obj.quantidadeRejeitada = double.tryParse(
                    map['quantidadeRejeitada'].toString() ??
                        map['quantidadeRejeitada'].toString());
              }
            });

            bool rv = existeArtigoNaLista(
                listaArtigoRececaoDisplayFiltro, _artigoRec.artigo);
            if (rv == false) listaArtigoRececaoDisplayFiltro.add(_artigoRec);

            lista_artigo_rececao.add(_artigoRec);
          }).toList();

          return lista_artigo_rececao;
        }
        final msg = json.decode(response.body);
        print("Ocorreu um erro " + msg["Message"]);
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  ArtigoRececaoCard rececaoItem(ArtigoRececao artigo) {
    String recebida =
        txtArtigoQtdRecebida.text = artigo.quantidadeRecebida.toString();
    String rejeitada =
        txtArtigoQtdRejeitada.text = artigo.quantidadeRejeitada.toString();
    ArtigoRececaoCard artigoRececao = ArtigoRececaoCard();
    final GlobalKey expansionTileKey = GlobalKey();

    if (posicao[idx] == true) {
      txtArtigoQtdRecebida.selection = TextSelection(
          baseOffset: 0, extentOffset: txtArtigoQtdRecebida.value.text.length);
      artigoRececao =
          buildRececaoItem(artigo, true, expansionTileKey, recebida, rejeitada);
    } else {
      artigoRececao = buildRececaoItem(
          artigo, false, expansionTileKey, recebida, rejeitada);
    }
    idx++;

    return artigoRececao;
  }

  ArtigoRececaoCard buildRececaoItem(ArtigoRececao artigo, bool state,
      GlobalKey key, String qtdRecebida, String qtdRejeitada) {
    txtArtigoQtdRecebida.text = artigo.quantidadeRecebida.toString();
    txtArtigoQtdRejeitada.text = artigo.quantidadeRejeitada.toString();

    return ArtigoRececaoCard(
      artigo: artigo,
      child: Column(
        children: <Widget>[
          ExpansionTile(
            key: key,
            maintainState: state,
            initiallyExpanded: state,

            // initiallyExpanded: state,
            title: Text(artigo.descricao,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blue, fontSize: 14)),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Artigo: " + artigo.artigo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blue, fontSize: 14)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Quantidade:    ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
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
                                          columnSpacing: 9.0,
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
                                                'Receção',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Rejeitada',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                              ),
                                            )
                                          ],
                                          rows: buildInventarioDataRow(
                                              artigo.artigo),
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
              ],
            ),
          ),

          //
        ],
      ),
    );
  }

  // escanear codigo de barra e pesquisar na lista dos artigos do editor

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
        lista_artigo_rececao.forEach((artigo) async {
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
            key: rececaoPesquisaKey,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Pesquise aqui...',
            ),
            onChanged: (value) {
              // items.clear();

              setState(() {
                if (value.length >= 0) {
                  items = PesquisaListaArtigo(lista_artigo_rececao, value);
                } else {
                  items = getListaArtigo(lista_artigo_rececao);
                }
              });
            },
            onEditingComplete: () {
              if (rececaoPesquisarController.text.length == 0) {
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
            controller: rececaoPesquisarController,
          )
        : new Text('Receção');
  }
}

class ArtigoRececaoCard extends Card {
  ArtigoRececaoCard(
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
  final ArtigoRececao artigo;
}
